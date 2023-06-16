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

def non_equi_join(tab1, tab2, field_tab1, field_tab2):
    for record1 in tab1:
        for record2 in tab2:
            valid_from = time_to_decimal(record2['valid_from'])
            valid_to = time_to_decimal(record2['valid_to'])
            valid_ref = time_to_decimal(record1['valid_ref'])
            if record1[field_tab1] == record2[field_tab2] and valid_from <= valid_ref <= valid_to:
                yield {**record1, f'fonte_desc': record2['desc']}  # merge dictionaries in Python 3.5+

def enrich_resource(resource):
    data = resource.read_rows()
    foreign_key = resource.schema.custom['temporalForeignKeys'][0]
    foreign_package = Package(f'https://raw.githubusercontent.com/splor-mg/ementario/{foreign_key["package"]}')
    foreign_resource_data = foreign_package.get_resource(foreign_key['ForeignKey']['reference']['resource']).read_rows()
    result = non_equi_join(data, foreign_resource_data, 'fonte_cod', foreign_key['ForeignKey']['reference']['fields'][0])
    return result
