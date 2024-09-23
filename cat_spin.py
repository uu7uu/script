from xspec import *
import os
import shutil
import argparse


# read the input argument from cmd/bash
def cmd():
    parser = argparse.ArgumentParser(description='command-line interface for MCMC python script')
    parser.add_argument('-i', '--input', type=str, help='the directory to the input file (ftable dir)')
    parser.add_argument('-o', '--output', type=str, help='the directory to the output file')
    parser.add_argument('-m', '--model', type=str, help='the directory to the goukerr model file for initializing')
    parser.add_argument('-LE', type=str, help='file name of the LE data')
    parser.add_argument('-ME', type=str, help='file name of the ME data')
    args = parser.parse_args()
    return args.input, args.output, args.model, args.LE, args.ME


# check if the input item is legal
def try_ftab(path, i):
    dirlist = os.listdir(path)
    return dirlist[i][0:4] == 'dir_'


# read the M, I, D of the directory name, return a list containing the parameters
def read_par(path, i):
    par = os.listdir(path)[i][4:]
    par = par.split('_')
    for i in range(3):
        par[i] = float(par[i])
    return par


# move the ftab file to the new directory
def move_ftab(oldPath, newPath, parList):
    M, I, D = parList
    oldDir = '{}/dir_{:.4f}_{:.4f}_{:.4f}/ftab1.dat'.format(oldPath, M, I, D)
    newDir = '{}/ftab1.dat'.format(newPath)
    shutil.copyfile(oldDir, newDir)
    
    
# fit the data and calculate the error
def data_fit_err(newPath, parList, modelPath, LE_name, ME_name):
    M, I, D = parList
    AllData('1:1 {}/{} 2:2 {}/{}'.format(newPath, LE_name, newPath, ME_name))
    AllData(1).ignore("**-2.0 10.0-**")
    AllData(2).ignore("**-10.0 25.0-**")
    AllData.ignore("bad")
    AllModels.initpackage("goukerr", "{}/lmodel.dat".format(modelPath))
    AllModels.lmod("goukerr", modelPath)
    m = Model("constant*tbabs*tbpcf*(simpl*nkerrbb+gaussian)", 
               setPars={1:"1 -1",
                        2:"5 -1",
                        10:'0.9 0.0001 0 0 0.9999 0.9999', 
                        11:'{}'.format(I), 
                        12:"{} -1".format(M), 
                        14:'{}'.format(D),
                        17:"1 -1",
                        18:"1 -1",
                        19:"6.4 0.01 6.4 6.4 6.97 6.97", 
                        20:"0.2 -1",
                        21:"1 0.01 0.00001 0.00001"})
    Fit.query = "yes"
    Fit.renorm()
    Fit.perform()
    for j in range(1, 22):
        if m(j).frozen == False:
            Fit.error(str(j))
        err = m(10).error
    a = m(10).values[0]
    p = Fit.nullhyp
    return a, err, p



if __name__ == '__main__':
    oldPath, newPath, modelPath, LE_name, ME_name= cmd()
    Xset.openLog('{}/log.txt'.format(newPath))
    with open('output.txt', 'a', encoding='UTF-8') as output:
        output.write('M, i, d, a, lb, ub\n')
    output.close()
    for i in range(0, len(os.listdir(oldPath))):
        if try_ftab(oldPath, i) == False:
            continue
        else:
            parList = read_par(oldPath, i)
            move_ftab(oldPath, newPath, parList)
            a, err, p = data_fit_err(newPath, parList, modelPath, LE_name, ME_name)
            with open('output.txt', mode='a', encoding='UTF-8') as output:
                output.write('{} {} {} {}\n'.format(parList, a, err, p))
            output.close()
