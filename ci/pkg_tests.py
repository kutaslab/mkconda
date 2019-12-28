import sys

# numpy 
try:
    import numpy as np
    print("numpy: ", np.__version__)
except Exception as fail:
    print(fail)
    sys.exit(1)

# matplotlib
try:
    import matplotlibx as mpl
    print("matplotlib: ", mpl.__version__)
except Exception as fail:
    print(fail)
    sys.exit(2)

sys.exit(0)

