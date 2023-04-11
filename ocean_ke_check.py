#!/usr/bin/env python3

# Call with ocean_scalar.nc as argument

import sys, netCDF4

d = netCDF4.Dataset(sys.argv[1])

ke = d.variables['ke_tot'][:]
kmax = ke.max()
print('Max ocean KE %.0f' % kmax)

if kmax > 1500:
    print("Stopping run because ocean KE %.0f exceeds limit" % kmax, file=sys.stderr)
    sys.exit(1)
