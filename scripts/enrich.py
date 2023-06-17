from scripts.utils import Package_dereference, enrich_resource
import csv

package = Package_dereference('datapackage.yaml')
resource = package.get_resource('exec_desp')
data = enrich_resource(resource)

with open('exec_desp.csv', 'w', newline='') as csvfile:
    headers = [*resource.schema.field_names, 'fonte_desc', 'uo_sigla', 'uo_desc']
    writer = csv.DictWriter(csvfile, fieldnames=headers)
    writer.writeheader()
    for row in data:
        writer.writerow(row)
