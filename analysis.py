from xspec import *
import os
import numpy as np
import shutil
import argparse
import matplotlib.pyplot as plt


# read the input argument from cmd/bash
def cmd():
    parser = argparse.ArgumentParser(description='command-line interface for MCMC python script')
    args = parser.parse_args()
    return args.output

def get_files():
    file_list = os.listdir()
    LE_files = [f for f in file_list if "LE_grouped" in f]
    ME_files = [f for f in file_list if "ME_grouped" in f]
    HE_files = [f for f in file_list if "HE_grouped" in f]
    LE_files.sort()
    ME_files.sort()
    HE_files.sort()
    return list(zip(LE_files, ME_files, HE_files))

def plot_power(LE_name):
    Plot.device = '/null'
    Plot.xAxis = "keV"
    Plot.setRebin(70, 10)
    Plot('mo ra')
    label = Plot.labels(1)
    rlabel = Plot.labels(2)
    title = "{}".format(LE_name[0:4])

    x1 = Plot.x(1)
    y1 = Plot.model(1)
    x2 = Plot.x(2)
    y2 = Plot.model(2)
    x3 = Plot.x(3)
    y3 = Plot.model(3)
    disk1 = Plot.addComp(1,1)
    disk2 = Plot.addComp(1,2)
    disk3 = Plot.addComp(1,3)
    po1 = Plot.addComp(2,1)
    po2 = Plot.addComp(2,2)
    po3 = Plot.addComp(2,3)

    e1 = Plot.x(1,2)
    e2 = Plot.x(2,2)
    e3 = Plot.x(3,2)
    e1_e = Plot.xErr(1,2)
    e2_e = Plot.xErr(2,2)
    e3_e = Plot.xErr(3,2)
    r1 = Plot.y(1,2)
    r2 = Plot.y(2,2)
    r3 = Plot.y(3,2)
    r1_e = Plot.yErr(1,2)
    r2_e = Plot.yErr(2,2)
    r3_e = Plot.yErr(3,2)

    # 使用matplotlib画图
    plt.figure(figsize=(12, 10))
    plt.subplot(211)
    plt.xscale('log')
    plt.yscale('log')
    plt.plot(x1,y1,'k-')
    plt.plot(x2,y2,'r-')
    plt.plot(x3,y3,'g-')
    plt.xlim(2,150)
    plt.ylim(0.005,10)
    plt.plot(x1,disk1,'c:')
    plt.plot(x2,disk2,'c:')
    plt.plot(x3,disk3,'c:')
    plt.plot(x1,po1,'m:')
    plt.plot(x2,po2,'m:')
    plt.plot(x3,po3,'m:')
    plt.ylabel(label[1],fontsize=20)
    plt.title(title,fontsize=16,loc='left')
    plt.title('Model: const*tbabs*(diskbb+powerlaw)', loc='center',fontsize=20)
    plt.yticks(size = 14)


    plt.subplot(212)
    plt.xscale('log')
    plt.yticks(size = 14)
    plt.xticks([5, 10, 20, 50, 100], ['5','10','20','50','100'], size=14)
    plt.xlim(2,100)
    plt.xlabel(label[0],fontsize=20)
    plt.ylabel(rlabel[1],fontsize=20)
    plt.errorbar(e1, r1, xerr=e1_e, yerr=r1_e,fmt='k.', linewidth=0.5, ms=1)
    plt.errorbar(e2, r2, xerr=e2_e, yerr=r2_e,fmt='r.', linewidth=0.5, ms=1)
    plt.errorbar(e3, r3 ,xerr=e3_e,yerr=r3_e,fmt='g.', linewidth=0.5, ms=1)

    plt.hlines(1.0,2,150,linestyles='-',colors='Lime',linewidth=1)
    plt.subplots_adjust(hspace=0)
    plt.savefig("{}_po.png".format(LE_name[0:4]), dpi=200, bbox_inches='tight')
    return

# fit the data and calculate the error
def data_fit_err(LE_name, ME_name, HE_name):
    AllData('1:1 {} 2:2 {} 3:3 {}'.format(LE_name, ME_name, HE_name))
    AllData(1).ignore("**-2.0 10.0-**")
    AllData(2).ignore("**-10.0 30.0-**")
    AllData(3).ignore("**-30.0 100.0-**")
    AllData.ignore("bad")
    m1 = Model("constant*tbabs*(diskbb+powerlaw)",
                setPars={2: 0.4})
    m2 = AllModels(2)
    m3 = AllModels(3)
    c2 = m2(1)
    c2.untie()
    c3 = m3(1)
    c3.untie()
    c1 = m1(1)
    c1.frozen = True
    Fit.query = "yes"
    Fit.renorm()
    Fit.perform()
    stat = np.float(Fit.statistic)
    dof = np.float(Fit.dof)
    chi  = stat/dof
    if chi<2:
        Xset.parallel.error = 20
        Fit.error("2-7, 13")
        plot_power(LE_name)
        Xset.save('{}_po.xcm'.format(LE_name[:4]))
    else:
        with open('list.txt', 'a') as file:
            file.write('{}\n'.format(LE_name[:4]))
    return 

if __name__ == '__main__':
    Xset.openLog('log.txt')
    parList = get_files()
    for LE_name, ME_name, HE_name in parList:
        xcm = '{}_po.xcm'.format(LE_name[:4])
        if os.path.exists(xcm): 
                continue
        else:
                data_fit_err(LE_name, ME_name, HE_name)
        Xset.closeLog()