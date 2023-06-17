from utils import Package_dereference
from rich import print as rprint

package = Package_dereference('datapackage.yaml')
resource = package.get_resource('exec_desp')
rprint(resource.schema.get_field('fonte_cod').description)

report = resource.validate()

[print(err) for err in report.flatten(['title', 'fieldName', 'rowNumber', 'message'])]