function[statuspar,cmdoutpar,fileparameter]= gtaprintparameter(fileparameter)
[fileparameter,pathparameter] = get_yamlfile('*.yaml')
fileparameter = strcat(pathparameter,fileparameter)
s = ' '
c = 'glotaran print -p'
commandparameter = [c,s,fileparameter]
[statuspar,cmdoutpar] = system(commandparameter,'-echo')
end