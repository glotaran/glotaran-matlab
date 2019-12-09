Optimization Result            |            |
-------------------------------|------------|
 Number of residual evaluation |          3 |
           Number of variables |          3 |
          Number of datapoints |   (96256,) |
            Degrees of freedom |      96253 |
                    Chi Square |   5.35e+05 |
            Reduced Chi Square |   5.56e+00 |
        Root Mean Square Error |   2.36e+00 |


# Model

_Type_: kinetic-spectrum

## Initial Concentration

* **Excitation**:
  * *Label*: Excitation
  * *Compartments*: ['C1', 'C2', 'C3']
  * *Parameters*: [Excitation.1: **1.00000e+00** *(fixed)*, Excitation.2: **0.00000e+00** *(fixed)*, Excitation.3: **0.00000e+00** *(fixed)*]

## K Matrix

* **k1**:
  * *Label*: k1
  * *Matrix*: 
    * *('C2', 'C1')*: kinetic.1: **9.67718e-03** *(StdErr: 4e-02 ,initial: 1.00000e-01)*
    * *('C3', 'C2')*: kinetic.2: **5.00000e-02** *(fixed)*
    * *('C3', 'C3')*: kinetic.3: **2.00000e-03** *(fixed)*
  

## Irf

* **irf1** (gaussian):
  * *Label*: irf1
  * *Type*: gaussian
  * *Center*: irf.center: **5.81164e+01** *(StdErr: 3e-02 ,initial: 6.80000e+01)*
  * *Width*: irf.width: **8.63506e+00** *(StdErr: 4e-02 ,initial: 4.00000e+00)*
  * *Backsweep*: True
  * *Backsweep Period*: constant.cI12500: **1.28000e+04** *(fixed)*

## Megacomplex

* **m1**:
  * *Label*: m1
  * *K Matrix*: ['k1']

## Dataset

* **data_TR2**:
  * *Label*: data_TR2
  * *Megacomplex*: ['m1']
  * *Initial Concentration*: Excitation
  * *Irf*: irf1

