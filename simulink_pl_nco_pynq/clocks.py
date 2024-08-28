import os
import xrfclk 

def _get_lmclk_devices():
    """Populate LMK and LMX devices.
    """
    
    # Search for devices if none exist
    if xrfclk.lmk_devices == [] and xrfclk.lmx_devices == []:
        xrfclk.xrfclk._find_devices()

def _get_custom_lmclks(loc):
    """Search for LMK and LMX clock files with a given address.
    """
    
    # Check type and value
    if not isinstance(loc, str):
        raise TypeError('Address location must be a string.')
    if not os.path.isdir(loc):
        raise ValueError('Address location does not exist.')
    
    # Variables
    lmk_loc = ''
    lmx_locs = []       # 存储多个lmx
    lmclk_loc = ''
    
    # Walk through directory and find .txt files
    for root, dirs, files in os.walk(loc):
        for d in dirs:
            for lmk in xrfclk.lmk_devices:
                if d == lmk['compatible']:
                    lmclk_loc = os.path.join(root, d)
                    break
    
    # Check variable is empty
    if lmclk_loc == '':
        raise RuntimeError('Could not find lmclk files.')
    
    # Use root directory to extract LMK and LMX locs
    for file in os.listdir(lmclk_loc):
        if file.endswith('.txt'):
            if 'LMK' in file:
                lmk_loc = os.path.join(lmclk_loc, file)
            elif 'LMX' in file:
                lmx_locs.append(os.path.join(lmclk_loc, file))   # 将找到文件名开始存在LMX的所有文件列表保存
    lmx_locs.sort()        
    # Check variables are empty
    if lmk_loc == '' or lmx_locs == '':
        raise RuntimeError('Could not find lmclk files.')
            
    return lmk_loc, lmx_locs

def _get_custom_lmclk_props(lmk_loc, lmx_locs):
    """Obtain the properties for LMK and LMX clocks using
    a set of address locations for clock files.
    """
    
    # Check type, value, and file format
    if not isinstance(lmk_loc, str):
        raise TypeError('TICS files must be a string.')
    if not os.path.isfile(lmk_loc):
        raise ValueError('TICS file paths do not exist.')
    if not lmk_loc[-4:] == '.txt':
        raise ValueError('TICS files must be .txt files.')
    
    # Strip file name from arguments for lmk
    lmk_name = lmk_loc.split('/')[-1]
        
    # Split lmk file name into chip and freq (strip .txt)
    lmk_split = lmk_name.strip('.txt').split('_')
       
    # Obtain LMKchip and freq components and
    # check for errors in format
    if len(lmk_split) == 2:
        lmk_chip, lmk_freq = lmk_split
        
    else:
        raise ValueError('TICS file names have incorrect format.')
    
    # Open files and parse registers
    with open(lmk_loc, 'r') as file:
        reg = [line.rstrip("\n") for line in file]
        lmk_reg = [int(r.split('\t')[-1], 16) for r in reg]

    # Populate TICS file dictionary, first only lmk
    clk_props = {
        'lmk' : {
            'file' : lmk_name,
            'loc'  : lmk_loc,
            'chip' : lmk_chip,
            'freq' : lmk_freq,
            'reg'  : lmk_reg
        }
    }
    
    # deal all lmx files, store chip, freq in lmxs; store 112 register value into lmxs_reg
    lmxs = []
    lmxs_reg = []
    for lmx in lmx_locs:
        temp = lmx.split('/')[-1]
        lmx_split = temp.strip('.txt').split('_')
        lmxs.append(lmx_split)
        with open(lmx, 'r') as file:
            reg = [line.rstrip("\n") for line in file]
            lmxs_reg.append([int(r.split('\t')[-1], 16) for r in reg])
    
    # append clk_props dictionary
    for i in range(len(lmxs)):
        clk_props.update(
            {lmxs[i][0]: {                 # LMXA2594
                'file': lmxs[i][0],        # LMXA2594
                'loc' : lmx_locs[i],       # /usr/local/share/pynq-venv/lib/python3.10/site-packages/pynq/xrfclk/lmk04208/LMXA2594_409.6.txt
                'chip': lmxs[i][0],        # LMXA2594
                'freq': lmxs[i][1],        # 409.6
                'reg' : lmxs_reg[i]        # 各寄存器数据
                }
            }
        )
    return clk_props

def _program_custom_lmclks(clk_props):
    """Program the LMK and LMX clocks using clock properties.
    """
        
    # Program each device
    for lmk in xrfclk.lmk_devices:
        xrfclk.xrfclk._write_LMK_regs(clk_props['lmk']['reg'], lmk)
    keys = ["LMXA2594", "LMXB2594", "LMXC2594"]    
    for i in range(len(xrfclk.lmx_devices)):
        xrfclk.xrfclk._write_LMX_regs(clk_props[keys[i]]['reg'], xrfclk.lmx_devices[i])

def set_custom_lmclks(loc):
    """Populate LMK and LMX clocks. Search for clock files.
    Obtain the properties of the clock files. Program the
    LMK and LMX clocks with the properties of the files.
    """
    
    # Ensure LMK and LMX devices are known
    _get_lmclk_devices()
    
    # Get custom ref clock locs
    #cwd = os.path.dirname(os.path.realpath(__file__))
    lmk_loc, lmx_locs = _get_custom_lmclks(loc)
    
    # Get custom ref clock props
    clk_props = _get_custom_lmclk_props(lmk_loc, lmx_locs)
    
    # Program custom ref clocks
    _program_custom_lmclks(clk_props)
        
