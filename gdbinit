# Find python package here --
# svn co svn://gcc.gnu.org/svn/gcc/trunk/libstdc++-v3/python

python
from os.path import expanduser
import sys
sys.path.insert(0, expanduser('~') + '/.workspaceenv/gdb_pprint')
from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers (None)
end
