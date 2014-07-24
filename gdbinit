# Find python package here --
# svn co svn://gcc.gnu.org/svn/gcc/trunk/libstdc++-v3/python

python
import sys
sys.path.insert(0, '/home/jeffjen/.workspaceenv/gdb_pprint')
from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers (None)
end
