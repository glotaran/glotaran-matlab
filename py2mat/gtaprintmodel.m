function[statusmodel,cmdoutmodel,filemodel]= gtaprintmodel(filemodel)
[filemodel,pathmodel] = get_yamlfile('*.yaml')
filemodel = strcat(pathmodel,filemodel)
s = ' '
c = 'glotaran print -m'
commandmodel = [c,s,filemodel]
[statusmodel,cmdoutmodel] = system(commandmodel)

end
