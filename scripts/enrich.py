from scripts.utils import Package_dereference, enrich_resource
from rich import print as rprint

package = Package_dereference('datapackage.yaml')
resource = package.get_resource('exec_desp')
data = enrich_resource(resource)

rprint(list(data))
