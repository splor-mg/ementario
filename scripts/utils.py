import jsonref
from frictionless import Package
import yaml
from pathlib import Path
from decimal import Decimal

def Package_dereference(path):
    with open(Path(path)) as fs:
        descriptor = yaml.safe_load(fs)
    descriptor_deref = jsonref.replace_refs(descriptor, base_uri='https://raw.githubusercontent.com/splor-mg/ementario/')
    result = Package(descriptor_deref)
    return result


def time_to_decimal(time_str):
    year, month = map(int, time_str.split('-'))
    return Decimal(year) + Decimal(month) / 13

def non_equi_join(x, y, key, key_y, resource):
    fields = set(y[0].keys()) - {'cod', 'seq', 'valid_from', 'valid_to'}
    for row in x:
        matched = False
        for row_y in y:
            valid_from = time_to_decimal(row_y['valid_from'])
            valid_to = time_to_decimal(row_y['valid_to'])
            valid_ref = time_to_decimal(row['valid_ref'])
            if row[key] == row_y[key_y] and valid_from <= valid_ref <= valid_to:
                desc = {f'{resource}_{field}':row_y[field] for field in fields}
                yield {**row, **desc}
                matched = True
                break
        if not matched:
                desc = {f'{resource}_{field}':None for field in fields}
                yield {**row, **desc}


def enrich_resource(resource):
    data = resource.read_rows()
    for foreign_key in resource.schema.custom['temporalForeignKeys']:
        foreign_package = Package(foreign_key['reference']['package'])
        foreign_resource_name = foreign_key['reference']['resource']
        foreign_resource_field_name = foreign_key['reference']['fields'][0]
        foreign_resource_data = foreign_package.get_resource(foreign_resource_name).read_rows()
        data = list(non_equi_join(data, foreign_resource_data, foreign_key['fields'], foreign_resource_field_name, foreign_resource_name))
    return data
