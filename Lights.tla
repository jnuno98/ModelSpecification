------------------------------- MODULE Lights -------------------------------
EXTENDS Integers
\* lightRotarySwitch on = 1, off = 0, auto = 2  cameraState Ready = 1 , NotReady = 0 , Dirty = 2
\* KeyState NoKeyInserted = 0 , KeyInserted = 1, KeyInIgnitionOnPosition = 2

\* pitmanArmForthBack = 1 -> Forth , pitmanArmForthBack = 2 -> Back , 0 -> neutral

\* pitmanArmUpDown Upward5 = 1 Upward7 = 2   ,  pitmanArmUpDown Downward5 = 3 Downward7 = 4 , 0 -> neutral

\* Booleans = daytimeLights, ambientLighting, hazardWarningSwitchOn, darknessModeSwitchOn, oncomingTraffic, 
\*              engineOn, allDoorsClosed, reverseGear, is_usa

\* Percentages 0-100 = brakeLight, blinkLeft, blinkRight, lowBeamLeft, lowBeamRight, taillampleft, taillampright,corneringLightLeft,
\*  corneringLightRight, reverseLight, highBeamOn

\* brightnessSensor 0–100000  ,  highBeamRange 0-300   , highBeamMotor 0-14 , brakePedal 0-225, voltageBattery 0-500
\*  currentSpeed 0 - 5000, steeringAngle ???


\* \A é o all
\* \E é o exists


VARIABLES 
    pc, lightRotarySwitch, pitmanArmForthBack, pitmanArmUpDown, daytimeLights, ambientLighting, hazardWarningSwitchOn, 
    darknessModeSwitchOn, oncomingTraffic, highBeamOn, brakeLight, blinkLeftAB, blinkRightAB, lowBeamLeft, lowBeamRight, 
    taillampleft, taillampright,corneringLightLeft, corneringLightRight, reverseLight, brightnessSensor, highBeamRange,
    engineOn, allDoorsClosed, brakePedal, reverseGear, voltageBattery, currentSpeed, highBeamMotor,
    exist_darknessModeSwitch, is_usa, blinkLeftC, blinkRightC,cameraState, keyState, taillampleftblink, taillamprightblink, flash

  
\*WANTS(p) == pc[p] = 2  
  
\*CRITICAL(p) == pc[p] = 3



\* Conjuntos de botoes para facilitar a escrita de todos eles a medida que o tempo passa
altos == /\ highBeamOn' = highBeamOn
         /\ highBeamRange' = highBeamRange
         /\ highBeamMotor' = highBeamMotor
         /\ pitmanArmForthBack'= pitmanArmForthBack

others == /\ brakePedal' = brakePedal
          /\ voltageBattery' = voltageBattery
          /\ currentSpeed' = currentSpeed
          /\ engineOn' = engineOn
          /\ cameraState' = cameraState
          /\ darknessModeSwitchOn' = darknessModeSwitchOn
          /\ hazardWarningSwitchOn' = hazardWarningSwitchOn
          /\ allDoorsClosed' = allDoorsClosed
          
sensors == /\ keyState' = keyState
           /\ lightRotarySwitch' = lightRotarySwitch
           /\ daytimeLights' = daytimeLights
           /\ ambientLighting' = ambientLighting
           /\ oncomingTraffic' = oncomingTraffic
           /\ brightnessSensor' = brightnessSensor
           /\ is_usa' = is_usa
           /\ exist_darknessModeSwitch' = exist_darknessModeSwitch
           
medios == /\ lowBeamLeft' = lowBeamLeft
          /\ lowBeamRight' = lowBeamRight
          /\ taillampleft' = taillampleft
          /\ taillampright' = taillampright
          /\ corneringLightLeft' = corneringLightLeft
          /\ corneringLightRight' = corneringLightRight
          
other_lights == /\ reverseGear' = reverseGear
                /\ reverseLight' = reverseLight
                /\ brakeLight' = brakeLight
                /\ daytimeLights' = daytimeLights
                
piscas == /\ pitmanArmUpDown' = pitmanArmUpDown
          /\ blinkLeftAB' = blinkLeftAB
          /\ blinkLeftC' = blinkLeftC
          /\ blinkRightAB' = blinkRightAB
          /\ blinkRightC' = blinkRightC
          /\ taillamprightblink' = taillamprightblink
          /\ taillampleftblink' = taillampleftblink


\* Invariante que indica todos os estados possiveis de cada botao
TypeOK == /\ cameraState \in 0..2
          /\ lightRotarySwitch \in 0..2
          /\ keyState \in 0..2
          /\ pitmanArmUpDown \in 0..4
          /\ pitmanArmForthBack \in 0..2
        
          /\ daytimeLights \in BOOLEAN
          /\ ambientLighting \in BOOLEAN
          /\ hazardWarningSwitchOn \in BOOLEAN
          /\ darknessModeSwitchOn \in BOOLEAN
          /\ oncomingTraffic \in BOOLEAN
          /\ engineOn \in BOOLEAN
          /\ allDoorsClosed \in BOOLEAN
          /\ reverseGear \in BOOLEAN
          /\ is_usa \in BOOLEAN
          /\ exist_darknessModeSwitch \in BOOLEAN
        
          
          /\ highBeamOn \in 0..100
          /\ brakeLight \in 0..100 
          /\ blinkLeftAB \in 0..100 
          /\ blinkRightAB \in 0..100 
          /\ blinkLeftC \in 0..100 
          /\ blinkRightC \in 0..100 
          /\ lowBeamLeft \in 0..100 
          /\ lowBeamRight \in 0..100 
          /\ taillampleft \in 0..100 
          /\ taillampright \in 0..100 
          /\ corneringLightLeft \in 0..100 
          /\ corneringLightRight \in 0..100 
          /\ reverseLight \in 0..100 
          /\ taillamprightblink \in 0..100
          /\ taillampleftblink \in 0..100
        
          /\ brightnessSensor \in 0..100000
          /\ highBeamRange \in 0..300
          /\ highBeamMotor \in 0..14
          /\ brakePedal \in 0..225
          /\ voltageBattery \in 0..500
          /\ currentSpeed \in 0..5000
          /\ pc \in 0..50
          /\ flash \in 0..10

\* pisca esquerdo USA -- se o carro for USA e tiver as daytime ligadas so acende o pisca a 50% senao liga a 100
piscaLEFT_usa == /\ IF is_usa /\ daytimeLights THEN blinkLeftAB' = 50 ELSE blinkLeftAB' = 100
                 /\ IF is_usa THEN (IF daytimeLights THEN taillampleftblink' = 50 ELSE taillampleftblink' = 100) ELSE blinkLeftC' = 100 /\ taillampleftblink' = 0

\* pisca direito USA análogo ao anterior 
piscaRIGHT_usa == /\ IF is_usa THEN (IF daytimeLights THEN taillamprightblink' = 50 ELSE taillamprightblink' = 100) ELSE blinkRightC' = 100 /\ taillamprightblink' = 0
                  /\ IF is_usa /\ daytimeLights THEN blinkRightAB' = 50 ELSE blinkRightAB' = 100


\*farois medios -- acende os farois medios a frente e atras com luminosidade máxima
lowbeam_start == /\ altos
                 /\ sensors
                 /\ piscas
                 /\ others
                 /\ other_lights
                 /\ lowBeamLeft' = 100
                 /\ lowBeamRight' = 100
                 /\ taillampleft' = 100
                 /\ taillampright' = 100
                 /\ corneringLightLeft' = corneringLightLeft
                 /\ corneringLightRight' = corneringLightRight
                 
\* desliga os medios -- faz a ação contrária ao lowbeam_start
lowbeam_end == /\ altos
               /\ sensors
               /\ piscas
               /\ others
               /\ other_lights
               /\ lowBeamLeft' = 0
               /\ lowBeamRight' = 0
               /\ taillampleft' = 0
               /\ taillampright' = 0
               /\ corneringLightLeft' = corneringLightLeft
               /\ corneringLightRight' = corneringLightRight


\* medios (low) económicos -- acende apenas com luminosidade 50% para poupar energia
low_save_power == /\ altos
                  /\ sensors
                  /\ piscas
                  /\ others
                  /\ other_lights
                  /\ lowBeamLeft' = 50
                  /\ lowBeamRight' = 50
                  /\ taillampleft' = 50
                  /\ taillampright' = 50
                  /\ corneringLightLeft' = corneringLightLeft
                  /\ corneringLightRight' = corneringLightRight
                  


\***********************************************************************************************************************
\***********************************************************************************************************************
\***********************************************************************************************************************
\* blinksOff, beamOff e other_lights_off podem ser usadas em conjunto para os carros que possuem darkmode

\* desligar os piscas todos
blinksOff == /\ altos
             /\ sensors
             /\ medios
             /\ others
             /\ other_lights
             /\ blinkLeftAB' = 0
             /\ IF is_usa THEN taillampleftblink' = 0 ELSE blinkLeftC' = 0 /\ taillampleftblink' = taillampleftblink
             /\ IF is_usa THEN taillamprightblink' = 0 ELSE blinkRightC' = 0 /\ taillamprightblink' = taillamprightblink
             /\ blinkRightAB' = 0
             /\ pitmanArmUpDown' = pitmanArmUpDown
             /\ pc' = pc
             /\ flash' = flash


\* desligar os farois todos
beamOff == /\ sensors
           /\ others
           /\ piscas
           /\ other_lights
           
           /\ highBeamOn' = 0
           /\ highBeamRange' = 0
           /\ highBeamMotor' = 0
           /\ pitmanArmForthBack'= pitmanArmForthBack 
           
           /\ lowBeamLeft' = 0
           /\ lowBeamRight' = 0
           /\ taillampleft' = 0
           /\ taillampright' = 0
           /\ corneringLightLeft' = 0
           /\ corneringLightRight' = 0
           
           

           
           
\*desligar as other lights
other_lights_off == /\ sensors
                    /\ others
                    /\ piscas
                    /\ altos
                    /\ medios
                    /\ reverseGear' = FALSE
                    /\ reverseLight' = 0
                    /\ brakeLight' = 0
                    /\ daytimeLights' = FALSE




\* Estado inicial do carro, tem tudo a 0 e a FALSE
Init == /\ cameraState = 0
        /\ lightRotarySwitch = 0
        /\ keyState = 0
        /\ pitmanArmUpDown = 0
        /\ pitmanArmForthBack = 0
        
        /\ daytimeLights = FALSE
        /\ ambientLighting = FALSE
        /\ hazardWarningSwitchOn = FALSE
        /\ darknessModeSwitchOn = FALSE
        /\ oncomingTraffic = FALSE
        /\ highBeamOn = 0
        /\ engineOn = FALSE
        /\ allDoorsClosed = TRUE
        /\ reverseGear = FALSE
        /\ is_usa = FALSE
        /\ exist_darknessModeSwitch = TRUE
        
        /\ brakeLight = 0
        /\ blinkLeftAB = 0
        /\ blinkRightAB = 0
        /\ blinkLeftC = 0
        /\ blinkRightC = 0
        /\ lowBeamLeft = 0
        /\ lowBeamRight = 0
        /\ taillampleft = 0
        /\ taillampright = 0
        /\ corneringLightLeft = 0
        /\ corneringLightRight = 0
        /\ reverseLight = 0
        /\ taillampleftblink = 0
        /\ taillamprightblink = 0
        
        /\ brightnessSensor = 0
        /\ highBeamRange = 0
        /\ highBeamMotor = 0
        /\ brakePedal = 0
        /\ voltageBattery = 0
        /\ currentSpeed = 0
        /\ pc = 0
        /\ flash = 1

    
\* mete o light rotary switch no modo On
liga_rotarySwitch == /\ altos
                     /\ brakePedal' = brakePedal
                     /\ voltageBattery' = voltageBattery
                     /\ currentSpeed' = currentSpeed
                     /\ engineOn' = FALSE
                     /\ cameraState' = cameraState
                     /\ darknessModeSwitchOn' = darknessModeSwitchOn
                     /\ hazardWarningSwitchOn' = hazardWarningSwitchOn
                     /\ allDoorsClosed' = allDoorsClosed
                     /\ medios
                     /\ other_lights
                     /\ piscas
                     /\ keyState' = 1
                     /\ lightRotarySwitch' = 1
                     /\ daytimeLights' = daytimeLights
                     /\ ambientLighting' = ambientLighting
                     /\ oncomingTraffic' = oncomingTraffic
                     /\ brightnessSensor' = brightnessSensor
                     /\ is_usa' = is_usa
                     /\ exist_darknessModeSwitch' = exist_darknessModeSwitch
                     /\ pc' = pc
                     /\ flash' = flash
                     
\* 
els14 == IF (lightRotarySwitch = 1 /\ keyState = 2) 
         THEN /\ lowBeamLeft' = 100 
              /\ lowBeamRight' = 100
              /\ taillampleft' = 100 
              /\ taillampright' = 100
              /\ corneringLightLeft' = corneringLightLeft
              /\ corneringLightRight' = corneringLightRight
         ELSE /\ medios
          
\* liga o carro, aqui muda o estado da chave e o engineOn que passa para true e as portas tambem ficam todas fechadas

start == /\ altos
         /\ brakePedal' = brakePedal
         /\ voltageBattery' = voltageBattery
         /\ currentSpeed' = currentSpeed
         /\ engineOn' = TRUE
         /\ cameraState' = cameraState
         /\ darknessModeSwitchOn' = darknessModeSwitchOn
         /\ hazardWarningSwitchOn' = hazardWarningSwitchOn
         /\ allDoorsClosed' = TRUE
         /\ keyState' = 2
         /\ els14
         /\ lightRotarySwitch' = lightRotarySwitch
         
         
         /\ daytimeLights' = daytimeLights
         /\ ambientLighting' = ambientLighting
         /\ oncomingTraffic' = oncomingTraffic
         /\ brightnessSensor' = brightnessSensor
         /\ is_usa' = is_usa
         /\ exist_darknessModeSwitch' = exist_darknessModeSwitch
         /\ other_lights
         /\ piscas
         /\ pc' = pc
         /\ flash' = flash
         

Divide(p,n) == \E q \in 1..n : p=q*n





\* ligar o hazard dependendo da origem do carro e se tem as daytimeLights ligadas
hazardWarning == /\ altos
                 /\ sensors
                 /\ medios

                 /\ other_lights
                 /\ IF is_usa /\ daytimeLights THEN blinkLeftAB' = 50 ELSE blinkLeftAB' = 100
                 /\ IF is_usa THEN (IF daytimeLights THEN taillampleftblink' = 50 ELSE taillampleftblink' = 100) ELSE blinkLeftC' = 100 /\ taillampleftblink' = 0
                 /\ IF is_usa THEN (IF daytimeLights THEN taillamprightblink' = 50 ELSE taillamprightblink' = 100) ELSE blinkRightC' = 100 /\ taillamprightblink' = 0
                 /\ pitmanArmUpDown' = pitmanArmUpDown
                 /\ IF is_usa /\ daytimeLights THEN blinkRightAB' = 50 ELSE blinkRightAB' = 100
                 /\ pc' = pc
                 /\ flash' = flash
                 
                 /\ brakePedal' = brakePedal
                 /\ voltageBattery' = voltageBattery
                 /\ currentSpeed' = currentSpeed
                 /\ engineOn' = engineOn
                 /\ cameraState' = cameraState
                 /\ darknessModeSwitchOn' = darknessModeSwitchOn
                 /\ hazardWarningSwitchOn' = TRUE
                 /\ allDoorsClosed' = allDoorsClosed
                 

\* desliga o hazard e se tiver o manipulo dos piscas em algum dos piscas, começa o ciclo de piscas          
hazardWarning_off == /\ altos
                     /\ sensors
                     /\ medios
                     /\ other_lights
                     
                     /\ IF pitmanArmUpDown = 2 
                        THEN pc' = 0
                        ELSE (IF pitmanArmUpDown = 4 
                              THEN pc' = 4 
                              ELSE /\ blinkLeftAB' = 0 /\ taillampleftblink' = 0 /\ blinkLeftC' = 0
                                   /\ blinkRightAB' = 0 /\ taillamprightblink' = 0 /\ blinkRightC' = 0)
                                   
                     /\ pitmanArmUpDown' = pitmanArmUpDown
                     /\ pc' = pc
                     /\ flash' = flash
                     /\ blinkLeftAB' = 0 
                     /\ taillampleftblink' = 0 
                     /\ blinkLeftC' = 0
                     /\ blinkRightAB' = 0 
                     /\ taillamprightblink' = 0 
                     /\ blinkRightC' = 0
                                
                     /\ brakePedal' = brakePedal
                     /\ voltageBattery' = voltageBattery
                     /\ currentSpeed' = currentSpeed
                     /\ engineOn' = engineOn
                     /\ cameraState' = cameraState
                     /\ darknessModeSwitchOn' = darknessModeSwitchOn
                     /\ hazardWarningSwitchOn' = FALSE
                     /\ allDoorsClosed' = allDoorsClosed
           
\* aqui é o início dos piscas, ou seja, antes de se entrar no loop de piscas temos a opção de ter o manipulo no estado neutro
InitPiscas == /\ altos
              /\ sensors
              /\ medios
              /\ others
              /\ other_lights
              /\ blinkLeftAB' = 0
              /\ IF is_usa THEN taillampleftblink' = 0 ELSE blinkLeftC' = 0 /\ taillampleftblink' = taillampleftblink
              /\ IF is_usa THEN taillamprightblink' = 0 ELSE blinkRightC' = 0 /\ taillamprightblink' = taillamprightblink
              /\ blinkRightAB' = 0
              /\ taillampleftblink' = taillampleftblink
              /\ pitmanArmUpDown' = 0
              /\ (/\ pc' = 0 \/ pc' = 4 \/ pc' = 8 \/ pc' = 12)
              /\ flash' = 0

\***** PISCAS *****
\* este estado coloca o manipulo dos piscas na posição 2, ou seja pisca para a direita na opção que fica engatado.
\* neste caso fazemos um ciclo de 6 piscas que é controlado pelo "flash".
\* depois deste estado entramos no PCO que verifica se o manipulo está em 2 e se ainda tem flashes para dar.
\* no inicio do processo de piscas ele tem 6 piscas para dar, depois disso, em PC1 ligamos o piscas da direita e passamos para o PC2
\* depois no PC2 desligamos os piscas e passamos o flash para o anterior menos 1. 
\* desta forma conseguimos controlar que apenas dá 6 piscas.
\* depois do PC2 volta-se a PC0 para verificar se ainda tem flashes para dar.
\* quando ficar sem flashes já não vai para o ciclo de piscas mas sim para a ação de desligar os piscas e colocar o manipulo a 0 que é o PC3
PCR == /\ altos
       /\ sensors
       /\ medios
       /\ others
       /\ other_lights
       /\ pitmanArmUpDown' = 2
       /\ blinkLeftAB' = blinkLeftAB
       /\ blinkLeftC' = blinkLeftC
       /\ blinkRightAB' = blinkRightAB
       /\ blinkRightC' = blinkRightC
       /\ taillamprightblink' = taillamprightblink
       /\ taillampleftblink' = taillampleftblink
       /\ pc' = 0
       /\ flash' = 6

PC0 == /\ pc = 0
       /\ altos
       /\ sensors
       /\ medios
       /\ others
       /\ other_lights
       /\ piscas
       /\ flash' = flash
       /\ IF pitmanArmUpDown = 2 /\ flash > 0 THEN pc' = 1 ELSE pc' = 3
        
PC1 == /\ pc = 1 
       /\ altos
       /\ sensors
       /\ medios
       /\ others
       /\ other_lights
       /\ blinkLeftAB' = blinkLeftAB
       /\ blinkLeftC' = blinkLeftC
       /\ piscaRIGHT_usa
       /\ taillampleftblink' = taillampleftblink
       /\ pitmanArmUpDown' = 2 
       /\ blinkRightAB' = 100
       /\ pc' = 2
       /\ flash' = flash



PC2 == /\ pc = 2 
       /\ altos
       /\ sensors
       /\ medios
       /\ others
       /\ other_lights
       /\ blinkLeftAB' = blinkLeftAB
       /\ blinkLeftC' = blinkLeftC
       /\ IF is_usa THEN taillamprightblink' = 0 ELSE blinkRightC' = 0 /\ taillamprightblink' = taillamprightblink
       /\ taillampleftblink' = taillampleftblink
       /\ pitmanArmUpDown' = 2
       /\ blinkRightAB' = 0
       /\ pc' = 0
       /\ flash' = flash - 1

PC3 == /\ pc = 3
       /\ altos
       /\ sensors
       /\ medios
       /\ others
       /\ other_lights
       /\ blinkLeftAB' = 0
       /\ IF is_usa THEN taillampleftblink' = 0 ELSE blinkLeftC' = 0 /\ taillampleftblink' = taillampleftblink
       /\ IF is_usa THEN taillamprightblink' = 0 ELSE blinkRightC' = 0 /\ taillamprightblink' = taillamprightblink
       /\ blinkRightAB' = 0
       /\ taillampleftblink' = taillampleftblink
       /\ pitmanArmUpDown' = 0
       /\ pc' = 0
       /\ flash' = 0

blinkRight == InitPiscas \/ PCR \/ PC0 \/ PC1 \/ PC2 \/ PC3

              

\* Este é análogo ao anterior, em vez de ser o pisca direito é o esquerdo
PCL == /\ altos
       /\ sensors
       /\ medios
       /\ others
       /\ other_lights
       /\ pitmanArmUpDown' = 4
       /\ blinkLeftAB' = blinkLeftAB
       /\ blinkLeftC' = blinkLeftC
       /\ blinkRightAB' = blinkRightAB
       /\ blinkRightC' = blinkRightC
       /\ taillamprightblink' = taillamprightblink
       /\ taillampleftblink' = taillampleftblink
       /\ pc' = 4
       /\ flash' = 6

PC4 == /\ pc = 4
       /\ altos
       /\ sensors
       /\ medios
       /\ others
       /\ other_lights
       /\ piscas
       /\ flash' = flash
       /\ IF /\ pitmanArmUpDown = 4 /\ flash > 0 THEN pc' = 5 ELSE pc' = 7
        
PC5 == /\ pc = 5 
       /\ altos
       /\ sensors
       /\ medios
       /\ others
       /\ other_lights
       /\ blinkRightAB' = blinkRightAB
       /\ blinkRightC' = blinkRightC
       /\ piscaLEFT_usa
       /\ taillamprightblink' = taillamprightblink
       /\ pitmanArmUpDown' = 4 
       /\ blinkLeftAB' = 100
       /\ pc' = 6
       /\ flash' = flash

PC6 == /\ pc = 6 
       /\ altos
       /\ sensors
       /\ medios
       /\ others
       /\ other_lights
       /\ blinkRightAB' = blinkRightAB
       /\ blinkRightC' = blinkRightC
       /\ IF is_usa THEN taillampleftblink' = 0 ELSE blinkLeftC' = 0 /\ taillampleftblink' = taillampleftblink
       /\ taillamprightblink' = taillamprightblink
       /\ pitmanArmUpDown' = 4
       /\ blinkLeftAB' = 0
       /\ pc' = 4
       /\ flash' = flash - 1

PC7 == /\ pc = 7
       /\ altos
       /\ sensors
       /\ medios
       /\ others
       /\ other_lights
       /\ blinkLeftAB' = 0
       /\ IF is_usa THEN taillampleftblink' = 0 ELSE blinkLeftC' = 0 /\ taillampleftblink' = taillampleftblink
       /\ IF is_usa THEN taillamprightblink' = 0 ELSE blinkRightC' = 0 /\ taillamprightblink' = taillamprightblink
       /\ blinkRightAB' = 0
       /\ pitmanArmUpDown' = 0
       /\ taillamprightblink' = taillamprightblink
       /\ pc' = 4
       /\ flash' = 0

blinkLeft == InitPiscas \/ PCL \/ PC4 \/ PC5 \/ PC6 \/ PC7


\* Este é o pisca tip direito, quando o manipulo nao engata, ou seja, faz apenas 3 flashes.
\* A modelação destes piscas foi feita da mesma maneira que os anteriores mas neste caso sairia do ciclo ao fim de 3 vezes.
PCTR == /\ altos
        /\ sensors
        /\ medios
        /\ others
        /\ other_lights
        /\ pitmanArmUpDown' = 1
        /\ blinkLeftAB' = blinkLeftAB
        /\ blinkLeftC' = blinkLeftC
        /\ blinkRightAB' = blinkRightAB
        /\ blinkRightC' = blinkRightC
        /\ taillamprightblink' = taillamprightblink
        /\ taillampleftblink' = taillampleftblink
        /\ pc' = 8
        /\ flash' = 3

PC8 == /\ pc = 8
       /\ altos
       /\ sensors
       /\ medios
       /\ others
       /\ other_lights
       /\ piscas
       /\ flash' = flash
       /\ IF /\ pitmanArmUpDown = 1 /\ flash > 0 THEN pc' = 9 ELSE pc' = 11
        
PC9 == /\ pc = 9 
       /\ altos
       /\ sensors
       /\ medios
       /\ others
       /\ other_lights
       /\ blinkLeftAB' = blinkLeftAB
       /\ blinkLeftC' = blinkLeftC
       /\ piscaRIGHT_usa
       /\ taillampleftblink' = taillampleftblink
       /\ pitmanArmUpDown' = 1 
       /\ blinkRightAB' = 100
       /\ pc' = 10
       /\ flash' = flash

PC10 == /\ pc = 10 
        /\ altos
        /\ sensors
        /\ medios
        /\ others
        /\ other_lights
        /\ blinkLeftAB' = blinkLeftAB
        /\ blinkLeftC' = blinkLeftC
        /\ IF is_usa THEN taillamprightblink' = 0 ELSE blinkRightC' = 0 /\ taillamprightblink' = taillamprightblink
        /\ taillampleftblink' = taillampleftblink
        /\ pitmanArmUpDown' = 1
        /\ blinkRightAB' = 0
        /\ pc' = 8
        /\ flash' = flash - 1

PC11 == /\ pc = 11
        /\ altos
        /\ sensors
        /\ medios
        /\ others
        /\ other_lights
        /\ blinkLeftAB' = 0
        /\ IF is_usa THEN taillampleftblink' = 0 ELSE blinkLeftC' = 0 /\ taillampleftblink' = taillampleftblink
        /\ IF is_usa THEN taillamprightblink' = 0 ELSE blinkRightC' = 0 /\ taillamprightblink' = taillamprightblink
        /\ blinkRightAB' = 0
        /\ taillampleftblink' = taillampleftblink
        /\ pitmanArmUpDown' = 0
        /\ pc' = 8
        /\ flash' = 0

blinkTipRight == InitPiscas \/ PCTR \/ PC8 \/ PC9 \/ PC10 \/ PC11



\* Análogo ao anterior 
PCTL == /\ altos
        /\ sensors
        /\ medios
        /\ others
        /\ other_lights
        /\ pitmanArmUpDown' = 3
        /\ blinkLeftAB' = blinkLeftAB
        /\ blinkLeftC' = blinkLeftC
        /\ blinkRightAB' = blinkRightAB
        /\ blinkRightC' = blinkRightC
        /\ taillamprightblink' = taillamprightblink
        /\ taillampleftblink' = taillampleftblink
        /\ pc' = 12
        /\ flash' = 3

PC12 == /\ pc = 12
        /\ altos
        /\ sensors
        /\ medios
        /\ others
        /\ other_lights
        /\ piscas
        /\ flash' = flash
        /\ IF /\ pitmanArmUpDown = 3 /\ flash > 0 THEN pc' = 13 ELSE pc' = 15
        
PC13 == /\ pc = 13 
        /\ altos
        /\ sensors
        /\ medios
        /\ others
        /\ other_lights
        /\ blinkRightAB' = blinkRightAB
        /\ blinkRightC' = blinkRightC
        /\ piscaLEFT_usa
        /\ taillamprightblink' = taillamprightblink
        /\ pitmanArmUpDown' = 3 
        /\ blinkLeftAB' = 100
        /\ pc' = 14
        /\ flash' = flash

PC14 == /\ pc = 14 
        /\ altos
        /\ sensors
        /\ medios
        /\ others
        /\ other_lights
        /\ blinkRightAB' = blinkRightAB
        /\ blinkRightC' = blinkRightC
        /\ IF is_usa THEN taillampleftblink' = 0 ELSE blinkLeftC' = 0 /\ taillampleftblink' = taillampleftblink
        /\ taillamprightblink' = taillamprightblink
        /\ pitmanArmUpDown' = 3
        /\ blinkLeftAB' = 0
        /\ pc' = 12
        /\ flash' = flash - 1

PC15 == /\ pc = 15
        /\ altos
        /\ sensors
        /\ medios
        /\ others
        /\ other_lights
        /\ blinkLeftAB' = 0
        /\ IF is_usa THEN taillampleftblink' = 0 ELSE blinkLeftC' = 0 /\ taillampleftblink' = taillampleftblink
        /\ IF is_usa THEN taillamprightblink' = 0 ELSE blinkRightC' = 0 /\ taillamprightblink' = taillamprightblink
        /\ blinkRightAB' = 0
        /\ taillamprightblink' = taillamprightblink
        /\ pitmanArmUpDown' = 0
        /\ pc' = 12
        /\ flash' = 0

blinkTipLeft == InitPiscas \/ PCTL \/ PC12 \/ PC13 \/ PC14 \/ PC15


\* PimanArm neutro verticalmente - quando está aqui quer dizer que não está nenhum pisca ligado
\* nesse caso, caso nao tenha o hazard ligado desligam-se os piscas
\* se o hazard estiver ligado invoca-se a ação de ligar o hazard mostrada anteriormente
neutralpitmanArmUpDown == /\ altos
                          /\ sensors
                          /\ medios
                          /\ others
                          /\ other_lights
                          /\ IF hazardWarningSwitchOn = FALSE THEN blinksOff ELSE hazardWarning
                          
                          
\* PitmanArm neutro horizontalmente - quando está aqui é porque o manipulo das luzes está neutro
\* neste caso desligam-se as luzes, sejam elas medios ou maximos
neutralpitmanArmForthBack == /\ piscas
                             /\ sensors
                             /\ others
                             /\ other_lights
                             /\ beamOff
                             /\ flash' = flash
                             /\ pc' = pc
  
  
\*********************************************************************************************************************\
\*********************************************************************************************************************\
\*                                                 ELS                                                               *\
\*********************************************************************************************************************\
\*********************************************************************************************************************\ 
  
                             
                                                 
\*********************************************************\
\*                        ELS-30                         *\ 
\*********************************************************\

\* esta ação coloca o manipulo na posição 1, ou seja, para a frente e liga os máximos
pitmanArmForth == /\ piscas
                  /\ sensors
                  /\ others
                  /\ other_lights   
                  /\ medios
                  /\ highBeamOn' = 100
                  /\ highBeamRange' = highBeamRange
                  /\ highBeamMotor' = highBeamMotor
                  /\ pitmanArmForthBack'= 1
                  /\ pc' = pc
                  /\ flash' = flash
            
\*********************************************************\
\*                        ELS-31                         *\ 
\*********************************************************\

\* aqui coloca o manipulo a 2, ou seja, para trás e coloca, tal como pedido, uma percentagem de highBeamMotor e range a 100             
pitmanArmManualBack == /\ piscas
                       
                       /\ keyState' = keyState
                       /\ lightRotarySwitch' = 1
                       /\ daytimeLights' = daytimeLights
                       /\ ambientLighting' = ambientLighting
                       /\ oncomingTraffic' = oncomingTraffic
                       /\ brightnessSensor' = brightnessSensor
                       /\ is_usa' = is_usa
                       /\ exist_darknessModeSwitch' = exist_darknessModeSwitch
           
                       /\ others
                       /\ other_lights   
                       /\ medios
                       /\ highBeamOn' = 100
                       /\ highBeamRange' = 100
                       /\ highBeamMotor' = 13
                       /\ pitmanArmForthBack'= 2   
                       /\ pc' = pc
                       /\ flash' = flash           
                       


\*********************************************************\
\*                        ELS-15                         *\ 
\*********************************************************\

\* se o keyState e o rotary switch estiverem a 1 entao liga os medios com luminosidade 50 para poupar energia
ELS_15 == /\ IF (keyState = 1 /\ lightRotarySwitch = 1) 
             THEN /\ low_save_power
                  /\ pc' = pc
                  /\ flash' = flash
             ELSE /\ altos
                  /\ others
                  /\ other_lights
                  /\ medios
                  /\ piscas
                  /\ sensors
                  /\ pc' = pc
                  /\ flash' = flash

\*********************************************************\
\*                        ELS-16                         *\
\*********************************************************\

\* mete a keyState e o rotary switch prontos para poder entrar no ciclo e desliga os medios
medios_off == /\ (keyState = 0 \/ keyState = 1)
              /\ lightRotarySwitch' = 2
              /\ keyState' = keyState
              /\ daytimeLights' = daytimeLights
              /\ ambientLighting' = ambientLighting
              /\ oncomingTraffic' = oncomingTraffic
              /\ brightnessSensor' = brightnessSensor
              /\ is_usa' = is_usa
              /\ exist_darknessModeSwitch' = exist_darknessModeSwitch
              /\ altos
              /\ lowBeamLeft' = 0
              /\ lowBeamRight' = 0
              /\ taillampleft' = 0
              /\ taillampright' = 0
              /\ corneringLightLeft' = corneringLightLeft
              /\ corneringLightRight' = corneringLightRight
              /\ others
              /\ other_lights
              /\ piscas
              /\ flash' = flash
              /\ pc' = 36
\* mete a keyState e o rotary switch prontos para poder entrar no ciclo e liga os medios
PCInit16 == /\ (keyState = 0 \/ keyState = 1)
            /\ lightRotarySwitch' = 2
            /\ keyState' = keyState
            /\ daytimeLights' = daytimeLights
            /\ ambientLighting' = ambientLighting
            /\ oncomingTraffic' = oncomingTraffic
            /\ brightnessSensor' = brightnessSensor
            /\ is_usa' = is_usa
            /\ exist_darknessModeSwitch' = exist_darknessModeSwitch
            /\ altos
            /\ lowBeamLeft' = 100
            /\ lowBeamRight' = 100
            /\ taillampleft' = 100
            /\ taillampright' = 100
            /\ corneringLightLeft' = corneringLightLeft
            /\ corneringLightRight' = corneringLightRight
            /\ others
            /\ other_lights
            /\ piscas
            /\ flash' = flash
            /\ pc' = 36

\* estes dois estados anteriores preparam o carro para poder entrar no ciclo a seguir para que haja a possibilidade de testar todos os casos.


\* se o keyState estiver a 0 ou a 1 (o carro nao está ligado) e o rotary switch esta no modo auto (PC36):
\* se tiver as luzes desligadas continuam desligadas(PC38), se nao desliga-as (PC37)

PC36 == /\ pc = 36
        /\ altos
        /\ medios
        /\ sensors
        /\ others
        /\ other_lights
        /\ piscas
        /\ IF (keyState = 0 \/ keyState = 1) /\ lightRotarySwitch = 2 
           THEN IF /\ lowBeamLeft = 0
                   /\ lowBeamRight = 0
                   /\ taillampleft = 0
                   /\ taillampright = 0 
                THEN pc' = 38 
                ELSE pc' = 37
           ELSE /\ pc' = 38
        /\ flash' = flash

PC37 == /\ pc = 37
        /\ altos
        /\ sensors
        /\ piscas
        /\ others
        /\ other_lights
        /\ lowbeam_end
        /\ flash' = flash
        /\ pc' = 36
        
PC38 == /\ pc = 38
        /\ altos
        /\ medios
        /\ sensors
        /\ others
        /\ other_lights
        /\ piscas
        /\ flash' = flash
        /\ pc' = 36
        
ELS_16 == medios_off \/ PCInit16 \/ PC36 \/ PC37 \/ PC38 


\*********************************************************\
\*                        ELS-18                         *\
\*********************************************************\

\* coloca o keyState e o rotary switch de maneira a entrar no estado seguinte
\* coloca duas possibilidades para a luz detetada, uma menor que 200 e outra maior que 250
\* desta maneira testamos todas as possibilidades
brightness == /\ keyState' = 2 
              /\ lightRotarySwitch' = 2 \/ lightRotarySwitch' = 1
              /\ daytimeLights' = daytimeLights
              /\ ambientLighting' = ambientLighting
              /\ oncomingTraffic' = oncomingTraffic
              /\ brightnessSensor' = 150 \/ brightnessSensor' = 470
              /\ is_usa' = is_usa
              /\ exist_darknessModeSwitch' = exist_darknessModeSwitch
              /\ altos
              /\ medios
              /\ brakePedal' = brakePedal
              /\ voltageBattery' = voltageBattery
              /\ currentSpeed' = currentSpeed
              /\ engineOn' = TRUE
              /\ cameraState' = cameraState
              /\ darknessModeSwitchOn' = darknessModeSwitchOn
              /\ hazardWarningSwitchOn' = hazardWarningSwitchOn
              /\ allDoorsClosed' = allDoorsClosed
              /\ other_lights
              /\ piscas
              /\ flash' = flash
              /\ pc' = 39

\* PC39 - Se o rotary switch estiver em auto e o keyState na ignition entao:
\* se o sensor da luz detetar luz menor que 200 entao liga as luzes (PC40)
\* se detetar mais de 250 desliga as luzes caso estejam ligadas (PC41)
\* caso contrário tudo se mantem igual (PC42)
PC39 == /\ pc = 39
        /\ altos
        /\ medios
        /\ sensors
        /\ others
        /\ other_lights
        /\ piscas
        /\ flash' = flash
        /\ IF (lightRotarySwitch = 2 /\ keyState = 2)
           THEN IF (brightnessSensor < 200)
                THEN pc' = 40
                ELSE IF (brightnessSensor > 250)
                     THEN pc' = 41
                     ELSE pc' = 42
           ELSE pc' = 42

PC40 == /\ pc = 40
        /\ lowbeam_start
        /\ flash' = flash
        /\ pc' = 39

PC41 == /\ pc = 41
        /\ lowbeam_end
        /\ flash' = flash
        /\ pc' = 39

PC42 == /\ pc = 42
        /\ altos
        /\ medios
        /\ sensors
        /\ others
        /\ other_lights
        /\ piscas
        /\ flash' = flash
        /\ pc' = 39

ELS_18 == brightness \/ PC39 \/ PC40 \/ PC41 \/ PC42

\*********************************************************\
\*                     ELS 21 e 25                       *\
\*********************************************************\

\* se existir o botão se darkness mode e estiver ligado entao desligam-se todas as luzes
\* caso contrario mantem-se tudo igual
darkness == IF exist_darknessModeSwitch /\ darknessModeSwitchOn
            THEN /\ blinksOff
                 /\ beamOff
                 /\ other_lights_off
                 /\ sensors
                 /\ others
            ELSE /\ altos
                 /\ others
                 /\ medios
                 /\ other_lights
                 /\ piscas
                 /\ sensors
                 /\ pc' = pc
                 /\ flash' = flash
                 
\*********************************************************\
\*                        ELS-22                         *\
\*********************************************************\

\* no caso de os medios (lowBeam) estarem ligados, entao as tails ligam-se também
\* no caso de nao estarem os medios ligados as estarem os maximos, ligam-se tambem as tails
\* no caso de nenhum destes se verificar desligam-se as tails
ELS_22 == /\ IF lowBeamLeft > 0 /\ lowBeamRight > 0 
             THEN /\ taillampleft' = lowBeamLeft 
                  /\ taillampright' = lowBeamRight
                  /\ lowBeamLeft' = lowBeamLeft
                  /\ lowBeamRight' = lowBeamRight
                  /\ corneringLightLeft' = corneringLightLeft
                  /\ corneringLightRight' = corneringLightRight
                  /\ altos
                  /\ others
                  /\ other_lights
                  /\ sensors
                  /\ piscas
                  /\ flash' = flash
                  /\ pc' = pc
             ELSE IF highBeamOn > 0
                  THEN /\ taillampleft' = highBeamOn 
                       /\ taillampright' = highBeamOn
                       /\ lowBeamLeft' = lowBeamLeft
                       /\ lowBeamRight' = lowBeamRight
                       /\ corneringLightLeft' = corneringLightLeft
                       /\ corneringLightRight' = corneringLightRight
                       /\ altos
                       /\ others
                       /\ other_lights
                       /\ sensors
                       /\ piscas
                       /\ flash' = flash
                       /\ pc' = pc
                  ELSE /\ taillampleft' = 0 
                       /\ taillampright' = 0
                       /\ lowBeamLeft' = lowBeamLeft
                       /\ lowBeamRight' = lowBeamRight
                       /\ corneringLightLeft' = corneringLightLeft
                       /\ corneringLightRight' = corneringLightRight
                       /\ altos
                       /\ others
                       /\ other_lights
                       /\ sensors
                       /\ piscas
                       /\ flash' = flash
                       /\ pc' = pc
                       
                       


\*********************************************************\
\*                 ELS-32, 33, 34 e 36                   *\
\*********************************************************\


PC19 == /\ pitmanArmForthBack' = 2
        /\ lightRotarySwitch' = 2
        /\ highBeamOn' = highBeamOn
        /\ highBeamRange' = highBeamRange
        /\ highBeamMotor' = highBeamMotor
        /\ keyState' = keyState
        /\ daytimeLights' = daytimeLights
        /\ ambientLighting' = ambientLighting
        /\ oncomingTraffic' = oncomingTraffic
        /\ brightnessSensor' = brightnessSensor
        /\ is_usa' = is_usa
        /\ exist_darknessModeSwitch' = exist_darknessModeSwitch
        /\ others
        /\ medios
        /\ other_lights
        /\ piscas
        /\ flash' = flash
        /\ pc' = 20
        
\* (PC20) se o manipulo estiver para trás e o rotary switch em auto vai para o PC21 explicado a seguir
\* caso isto nao aconteça permanece tudo igual (PC23)
PC20 == /\ pc = 20
        /\ altos
        /\ others
        /\ sensors
        /\ other_lights
        /\ medios
        /\ piscas
        /\ flash' = flash
        /\ IF /\ pitmanArmForthBack = 2 /\ lightRotarySwitch = 2 THEN pc' = 21 ELSE pc' = 23 

\* (PC21) se a camara estiver ready, nao vierem carros e a velocidade for maior de 30km/h entao:
\* se a velocidade for maior ou igual a 170, mete-se a range a 300, senao vai depender da velocidade pela expressão apresentada
\* se a velocidade for maior ou igual a 120 liga-se os maximos a 100, senao vai depender tambem da velocidade
\* se nada disto se verificar, se vierem carros (PC22): o range passa para 65 e ligam-se os medios
\* no caso de nenhuma das opçĩes acima se verificar deixa-se tudo como estava
\* neste caso para fazer os cálculos utilizamos aproximações porque não aceita decimais
PC21 == /\ pc = 21 
        /\ IF /\ cameraState = 1 /\ oncomingTraffic = FALSE /\ currentSpeed > 30
           THEN /\ IF currentSpeed >= 170 THEN highBeamRange = 300 ELSE highBeamRange = Divide(11,100)*currentSpeed^2+81 
                /\ IF currentSpeed >= 120 THEN highBeamOn = 100 ELSE highBeamOn = Divide(7,9) * currentSpeed + 7
                /\ highBeamRange' = highBeamRange
                /\ highBeamMotor' = highBeamMotor
                /\ pitmanArmForthBack'= pitmanArmForthBack
                /\ medios
                /\ others
                /\ other_lights
                /\ piscas
                /\ sensors
                /\ flash' = flash
                /\ pc' = 20
                
           ELSE /\ altos
                /\ medios
                /\ others
                /\ other_lights
                /\ piscas
                /\ sensors
                /\ flash' = flash
                /\ pc' = 22
                
PC22 == /\ pc = 22
        /\ IF /\ cameraState = 1 /\ oncomingTraffic = TRUE
           THEN /\ highBeamRange = 65
                /\ highBeamOn' = 0 \* como nao aceita decimais colocamos 0, assim desligam-se os maximos
                /\ sensors
                /\ piscas
                /\ others
                /\ other_lights
                /\ lowBeamLeft' = 100
                /\ lowBeamRight' = 100
                /\ taillampleft' = 100
                /\ taillampright' = 100
                /\ corneringLightLeft' = corneringLightLeft
                /\ corneringLightRight' = corneringLightRight
                /\ flash' = flash
                /\ pc' = 20
           ELSE /\ others
                /\ altos
                /\ other_lights
                /\ sensors
                /\ medios
                /\ piscas
                /\ flash' = flash
                /\ pc' = 23

PC23 == /\ pc = 23
        /\ others
        /\ altos
        /\ other_lights
        /\ sensors
        /\ medios
        /\ piscas
        /\ flash' = flash
        /\ pc' = 20
        
Adapt_HighBeam == PC19 \/ PC20 \/ PC21 \/ PC22 \/ PC23

\*********************************************************\
\*                        ELS-38                         *\
\*********************************************************\

\* Se o manipulo das luzes estiver neutro e o rotary switch no modo auto: ligam-se as luzes
\* caso contrario nada acontece
ELS_38 == IF pitmanArmForthBack = 0 /\ lightRotarySwitch = 2
          THEN /\ lowbeam_start
               /\ flash' = flash
               /\ pc' = pc
          ELSE /\ altos
               /\ sensors
               /\ piscas
               /\ others
               /\ other_lights
               /\ medios
               /\ flash' = flash
               /\ pc' = pc
               
\*********************************************************\               
\*                        ELS-39                         *\
\*********************************************************\

\* estado que permite ir para os estados que queremos testar -> coloca o brake pedal com um angulo de 0
brake_menos3 == /\ brakePedal' = 0
                /\ voltageBattery' = voltageBattery
                /\ currentSpeed' = currentSpeed
                /\ engineOn' = engineOn
                /\ cameraState' = cameraState
                /\ darknessModeSwitchOn' = darknessModeSwitchOn
                /\ hazardWarningSwitchOn' = hazardWarningSwitchOn
                /\ allDoorsClosed' = allDoorsClosed
                /\ altos
                /\ sensors
                /\ medios
                /\ other_lights
                /\ piscas
                /\ pc' = 30
                /\ flash' = flash

\* outro estado para testar o que queremos -> coloca o brake pedal a maior que 3
brake_mais3 == /\ brakePedal' = 7
               /\ voltageBattery' = voltageBattery
               /\ currentSpeed' = currentSpeed
               /\ engineOn' = engineOn
               /\ cameraState' = cameraState
               /\ darknessModeSwitchOn' = darknessModeSwitchOn
               /\ hazardWarningSwitchOn' = hazardWarningSwitchOn
               /\ allDoorsClosed' = allDoorsClosed
               /\ altos
               /\ sensors
               /\ medios
               /\ other_lights
               /\ piscas
               /\ pc' = 30
               /\ flash' = flash

\* (PC30) se o brake pedal esta defletido com um grau maior que 3 entao:
\* (PC31) liga a luz de travagem a 100
\* (PC32) caso contrário, se o angulo for menor que um, desliga a luz de travagem, senao continua ligada
PC30 == /\ pc = 30
        /\ IF brakePedal > 3 THEN pc' = 31 ELSE pc' = 32
        /\ altos
        /\ sensors
        /\ medios
        /\ piscas
        /\ others
        /\ other_lights
        /\ flash' = flash

PC31 == /\ pc = 31
        /\ brakeLight' = 100
        /\ reverseGear' = reverseGear
        /\ reverseLight' = reverseLight
        /\ daytimeLights' = daytimeLights
        /\ altos
        /\ sensors
        /\ medios
        /\ others
        /\ piscas
        /\ flash' = flash
        /\ pc' = 30

PC32 == /\ pc = 32
        /\ IF brakePedal < 1
           THEN /\ brakeLight' = 0
                /\ reverseGear' = reverseGear
                /\ reverseLight' = reverseLight
                /\ daytimeLights' = daytimeLights
                /\ altos
                /\ sensors
                /\ medios
                /\ others
                /\ piscas
                /\ flash' = flash
                /\ pc' = 30
           ELSE /\ brakeLight = 100
                /\ reverseGear' = reverseGear
                /\ reverseLight' = reverseLight
                /\ daytimeLights' = daytimeLights
                /\ altos
                /\ sensors
                /\ medios
                /\ others
                /\ piscas
                /\ flash' = flash
                /\ pc' = 30 

ELS_39 == brake_menos3 \/ brake_mais3 \/ PC30 \/ PC31 \/ PC32

\*********************************************************\
\*                        ELS-40                         *\
\*********************************************************\

\* coloca o brake pedal a menos de 40, no caso, mete a 0
brake_menos40 == /\ brakePedal' = 0
                 /\ voltageBattery' = voltageBattery
                 /\ currentSpeed' = currentSpeed
                 /\ engineOn' = engineOn
                 /\ cameraState' = cameraState
                 /\ darknessModeSwitchOn' = darknessModeSwitchOn
                 /\ hazardWarningSwitchOn' = hazardWarningSwitchOn
                 /\ allDoorsClosed' = allDoorsClosed
                 /\ altos
                 /\ sensors
                 /\ medios
                 /\ other_lights
                 /\ piscas
                 /\ pc' = 33
                 /\ flash' = flash

\* neste caso coloca o brake pedal com um angulo maior que 40
brake_mais40 == /\ brakePedal' = 85
                /\ voltageBattery' = voltageBattery
                /\ currentSpeed' = currentSpeed
                /\ engineOn' = engineOn
                /\ cameraState' = cameraState
                /\ darknessModeSwitchOn' = darknessModeSwitchOn
                /\ hazardWarningSwitchOn' = hazardWarningSwitchOn
                /\ allDoorsClosed' = allDoorsClosed
                /\ altos
                /\ sensors
                /\ medios
                /\ other_lights
                /\ piscas
                /\ pc' = 33
                /\ flash' = flash


\* (PC33) se o angulo for maior que 40 entao: (PC34) senão , se for 0 (PC35), senao (PC34)
\* (PC34) liga a luz de travagem a 100
\* (PC35) desliga a luz de travagem
PC33 == /\ pc = 33
        /\ altos
        /\ others
        /\ other_lights
        /\ medios
        /\ sensors
        /\ piscas
        /\ IF brakePedal > 40 THEN pc' = 34 ELSE IF brakePedal = 0 THEN pc' = 35 ELSE pc' = 34
        /\ flash' = flash

PC34 == /\ pc = 34
        /\ reverseGear' = reverseGear
        /\ reverseLight' = reverseLight
        /\ brakeLight' = 100
        /\ daytimeLights' = daytimeLights
        /\ altos
        /\ medios
        /\ others
        /\ sensors
        /\ piscas
        /\ flash' = flash
        /\ pc' = 35

PC35 == /\ pc = 35
        /\ reverseGear' = reverseGear
        /\ reverseLight' = reverseLight
        /\ brakeLight' = 0
        /\ daytimeLights' = daytimeLights
        /\ altos
        /\ medios
        /\ others
        /\ sensors
        /\ piscas
        /\ flash' = flash
        /\ pc' = 33
        
ELS_40 == brake_menos40 \/ brake_mais40 \/ PC33 \/ PC34 \/ PC35

\*********************************************************\
\*                      ELS 27 e 41                      *\
\*********************************************************\

\* se estiver engatada a mudança de marcha a trás, entao liga-se a luz de reverse e as cornering lights, senao mantem-se tudo
ELS_27_41 == IF reverseGear = TRUE 
             THEN /\ reverseGear' = reverseGear
                  /\ reverseLight' = 100
                  /\ brakeLight' = brakeLight
                  /\ daytimeLights' = daytimeLights
                  /\ altos
                  /\ lowBeamLeft' = lowBeamLeft
                  /\ lowBeamRight' = lowBeamRight
                  /\ taillampleft' = taillampleft
                  /\ taillampright' = taillampright
                  /\ corneringLightLeft' = 100
                  /\ corneringLightRight' = 100
                  /\ others
                  /\ piscas
                  /\ sensors
                  /\ pc' = pc
                  /\ flash' = flash
             ELSE /\ altos
                  /\ medios
                  /\ others
                  /\ other_lights
                  /\ piscas
                  /\ sensors
                  /\ pc' = pc
                  /\ flash' = flash 


\*********************************************************\
\*                        ELS-24                         *\
\*********************************************************\

\* coloca o carro num estado pronto a entrar no estado seguinte que queremos testar se funcionaria
teste24 == /\ altos
           /\ sensors
           /\ other_lights
            
           /\ currentSpeed' = 5 
           /\ lowBeamLeft' = 100
           /\ lowBeamRight' = 100 
           /\ taillampleft' = 100 
           /\ taillampright' = 100 
           /\ (\/ pitmanArmUpDown' = 1 
               \/ pitmanArmUpDown' = 2
               \/ pitmanArmUpDown' = 3
               \/ pitmanArmUpDown' = 4
               \/ pitmanArmUpDown' = 0)
            
           /\ brakePedal' = brakePedal
           /\ voltageBattery' = voltageBattery
           /\ engineOn' = engineOn
           /\ cameraState' = cameraState
           /\ darknessModeSwitchOn' = darknessModeSwitchOn
           /\ hazardWarningSwitchOn' = hazardWarningSwitchOn
           /\ allDoorsClosed' = allDoorsClosed
            
           /\ corneringLightLeft' = corneringLightLeft
           /\ corneringLightRight' = corneringLightRight
            
           /\ blinkLeftAB' = blinkLeftAB
           /\ blinkLeftC' = blinkLeftC
           /\ blinkRightAB' = blinkRightAB
           /\ blinkRightC' = blinkRightC
           /\ taillamprightblink' = taillamprightblink
           /\ taillampleftblink' = taillampleftblink
            
           /\ pc' = 43
           /\ flash' = flash

\* (PC43) se a velocidade for menor que 10, os lowbeams e as tails estiverem ligadas e o manipulo dos piscas nao estiver em neutro entao:
\* se o manipulo estiver para a direita (PC44) liga-se a cornering light direita
\* se nao (PC45) liga-se a cornering light esquerda
\* (PC46) no caso de nao estar em nenhum destes estados mantem-se tudo igual            
PC43 == /\ pc = 43
        /\ altos
        /\ medios
        /\ others
        /\ other_lights
        /\ sensors
        /\ piscas
        /\ IF (currentSpeed < 10 /\ (lowBeamLeft = 100 /\ lowBeamRight = 100 /\ taillampleft = 100 /\ taillampright = 100) /\ pitmanArmUpDown /= 0)
           THEN IF (pitmanArmUpDown = 1 \/ pitmanArmUpDown = 2) 
                THEN pc' = 44
                ELSE pc' = 45
           ELSE pc' = 46
        /\ flash' = flash
        
PC44 == /\ pc = 44
        /\ lowBeamLeft' = lowBeamLeft
        /\ lowBeamRight' = lowBeamRight
        /\ taillampleft' = taillampleft
        /\ taillampright' = taillampright
        /\ corneringLightLeft' = corneringLightLeft
        /\ corneringLightRight' = 100
        /\ altos
        /\ sensors
        /\ piscas
        /\ others
        /\ other_lights
        /\ pc' = 43
        /\ flash' = flash
 
PC45 == /\ pc = 45
        /\ lowBeamLeft' = lowBeamLeft
        /\ lowBeamRight' = lowBeamRight
        /\ taillampleft' = taillampleft
        /\ taillampright' = taillampright
        /\ corneringLightRight' = corneringLightRight
        /\ corneringLightLeft' = 100
        /\ altos
        /\ sensors
        /\ piscas
        /\ others
        /\ other_lights
        /\ pc' = 43
        /\ flash' = flash

PC46 == /\ pc = 46
        /\ altos
        /\ medios
        /\ sensors
        /\ piscas
        /\ others
        /\ other_lights
        /\ pc' = 43
        /\ flash' = flash

ELS_24 == teste24 \/ PC43 \/ PC44 \/ PC45 \/ PC46



\*********************************************************************************************************************\
\*                                                                                                                   *\
\*                                               INVARIANTES                                                         *\
\*                                                                                                                   *\
\*********************************************************************************************************************\

\* Invariante que indica que quando a chave não está colocada ou nao 
\* esta na ignição, o carro nao pode estar ligado, caso contrário pode
KeyInv == IF 
          \/ keyState = 0 
          \/ keyState = 1
          THEN engineOn = FALSE
          ELSE engineOn = TRUE

\* Invariante: se existe o botao do modo escuro, entao esse botao pode 
\* estar desligado ou ligado mas se nao existir tem que estar desligado
DarkInv == IF exist_darknessModeSwitch = TRUE
           THEN (\/ darknessModeSwitchOn = TRUE 
                 \/ darknessModeSwitchOn = FALSE)
           ELSE darknessModeSwitchOn = FALSE
           
           
\* Invariante: Só se pode ligar o carro quando todas as portas estiverem fechadas
DoorsInv == IF allDoorsClosed = TRUE
            THEN 
            \/ engineOn = TRUE
            \/ engineOn = FALSE
            ELSE engineOn = FALSE
            
\* Invariante: Se o carro nao for usa, entao os taillampblink (right e left) estao sempre a 0
NotUsa == IF is_usa = FALSE 
          THEN taillamprightblink = 0 /\ taillampleftblink = 0 
          ELSE taillamprightblink >= 0 \/ taillampleftblink >= 0  

              

\*********************************************************************************************************************\
\*                                                                                                                   *\
\*                                           PROPRIEDADES                                                            *\
\*                                                                                                                   *\
\*********************************************************************************************************************\

\* testa se todas as portas estão fechadas quando o carro está a trabalhar
prop_start == IF keyState = 2 
              THEN allDoorsClosed = TRUE
              ELSE allDoorsClosed = TRUE \/ allDoorsClosed = FALSE

\* testa as els relativas ao hazard
prop_hazard == IF hazardWarningSwitchOn = TRUE /\ darknessModeSwitchOn = FALSE
               THEN blinkLeftAB > 0 /\ blinkRightAB > 0
               ELSE blinkLeftAB = 0 \/ blinkRightAB = 0

\* testa os máximos manuais - els 30 e 31
prop_man_high == IF pitmanArmForthBack = 1 
                 THEN highBeamOn = 100 
                 ELSE IF pitmanArmForthBack = 2 
                      THEN /\ highBeamOn = 100
                           /\ highBeamRange = 100
                           /\ highBeamMotor = 13
                 ELSE highBeamOn = 0

\* testa se a els 14 é cumprida
prop_14 == IF (lightRotarySwitch = 1 /\ keyState = 2) 
           THEN /\ lowBeamLeft = 100 
                /\ lowBeamRight = 100
                /\ taillampleft = 100 
                /\ taillampright = 100
           ELSE /\ lowBeamLeft >= 0 
                /\ lowBeamRight >= 0
                /\ taillampleft >= 0 
                /\ taillampright >= 0
                
\* testa se a els 15 é cumprida
prop_15 == IF (keyState = 1 /\ lightRotarySwitch = 1) 
           THEN /\ lowBeamLeft = 50
                /\ lowBeamRight = 50
                /\ taillampleft = 50
                /\ taillampright = 50
           ELSE /\ lowBeamLeft = 0
                /\ lowBeamRight = 0
                /\ taillampleft = 0
                /\ taillampright = 0
                
\* testa se a els 16 é cumprida                
prop_16 == IF ((keyState = 0 \/ keyState = 1) /\ lightRotarySwitch = 2)
           THEN /\ lowBeamLeft = 0
                /\ lowBeamRight = 0
                /\ taillampleft = 0
                /\ taillampright = 0
           ELSE /\ lowBeamLeft >= 0
                /\ lowBeamRight >= 0
                /\ taillampleft >= 0
                /\ taillampright >= 0

\* testa se a els 18 é cumprida
prop_18 == IF (lightRotarySwitch = 2 /\ keyState = 2)
           THEN IF (brightnessSensor < 200) 
                THEN /\ lowBeamLeft = 100
                     /\ lowBeamRight = 100
                     /\ taillampleft = 100
                     /\ taillampright = 100
                ELSE IF (brightnessSensor > 250)
                     THEN /\ lowBeamLeft = 0
                          /\ lowBeamRight = 0
                          /\ taillampleft = 0
                          /\ taillampright = 0
                     ELSE /\ lowBeamLeft >= 0
                          /\ lowBeamRight >= 0
                          /\ taillampleft >= 0
                          /\ taillampright >= 0
           ELSE /\ lowBeamLeft >= 0
                /\ lowBeamRight >= 0
                /\ taillampleft >= 0
                /\ taillampright >= 0

\* testa se as els 21 e 25 sao cumpridas
prop_darkness == IF (exist_darknessModeSwitch /\ darknessModeSwitchOn)
                 THEN /\ blinkLeftAB = 0
                      /\ IF is_usa THEN taillampleftblink = 0 ELSE blinkLeftC = 0 /\ taillampleftblink = 0
                      /\ IF is_usa THEN taillamprightblink = 0 ELSE blinkRightC = 0 /\ taillamprightblink = 0
                      /\ blinkRightAB = 0
                      /\ highBeamOn = 0
                      /\ highBeamRange = 0
                      /\ highBeamMotor = 0
                      /\ lowBeamLeft = 0
                      /\ lowBeamRight = 0
                      /\ taillampleft = 0
                      /\ taillampright = 0
                      /\ corneringLightLeft = 0
                      /\ corneringLightRight = 0
                      /\ reverseGear = FALSE
                      /\ reverseLight = 0
                      /\ brakeLight = 0
                      /\ daytimeLights = FALSE
                 ELSE /\ blinkLeftAB >= 0
                      /\ IF is_usa THEN taillampleftblink >= 0 ELSE blinkLeftC >= 0 /\ taillampleftblink >= 0
                      /\ IF is_usa THEN taillamprightblink >= 0 ELSE blinkRightC >= 0 /\ taillamprightblink >= 0
                      /\ blinkRightAB >= 0
                      /\ highBeamOn >= 0
                      /\ highBeamRange >= 0
                      /\ highBeamMotor >= 0
                      /\ lowBeamLeft >= 0
                      /\ lowBeamRight >= 0
                      /\ taillampleft >= 0
                      /\ taillampright >= 0
                      /\ corneringLightLeft >= 0
                      /\ corneringLightRight >= 0
                      /\ (reverseGear = FALSE \/ reverseGear = TRUE)
                      /\ reverseLight >= 0
                      /\ brakeLight >= 0
                      /\ (daytimeLights = FALSE \/ daytimeLights = TRUE)

\* testa se a els 22 é cumprida
prop_22 == IF ((lowBeamLeft > 0 /\ lowBeamRight > 0) \/ highBeamOn > 0)
           THEN /\ taillampleft > 0
                /\ taillampright > 0
           ELSE /\ taillampleft = 0
                /\ taillampright = 0

\* testa se a els 32 é cumprida
prop_32 == IF (pitmanArmForthBack = 2 /\ lightRotarySwitch = 2) 
           THEN highBeamOn > 0 \/ (lowBeamLeft > 0 /\ lowBeamRight > 0)
           ELSE IF pitmanArmForthBack = 0 
                THEN highBeamOn = 0
                ELSE highBeamOn >= 0

\* testa se a els 33 é cumprida em conjunto com a prop_33_2 a seguir
prop_33_1 == IF (pitmanArmForthBack = 2 /\ lightRotarySwitch = 2 /\ cameraState = 1 /\ oncomingTraffic = FALSE /\ currentSpeed > 30)
             THEN IF currentSpeed >= 170 
                  THEN highBeamRange = 300 
                  ELSE highBeamRange = Divide(11,100)*currentSpeed^2+81
             ELSE highBeamRange >= 0
             
prop_33_2 == IF (pitmanArmForthBack = 2 /\ lightRotarySwitch = 2 /\ cameraState = 1 /\ oncomingTraffic = FALSE /\ currentSpeed > 30)
             THEN IF currentSpeed >= 120 
                  THEN highBeamOn = 100 
                  ELSE highBeamOn = Divide(7,9) * currentSpeed + 7
             ELSE highBeamOn >= 0

\* testa se a els 34 é cumprida    
prop_34 == IF (pitmanArmForthBack = 2 /\ lightRotarySwitch = 2 /\ cameraState = 1 /\ oncomingTraffic = TRUE)
           THEN /\ highBeamRange = 65
                /\ lowBeamLeft = 100
                /\ lowBeamRight = 100
                /\ taillampleft = 100
                /\ taillampright = 100
           ELSE /\ highBeamRange >= 0
                /\ lowBeamLeft >= 0
                /\ lowBeamRight >= 0
                /\ taillampleft >= 0
                /\ taillampright >= 0
                
\* testa se a els 38 é cumprida                
prop_38 == IF (pitmanArmForthBack = 0 /\ lightRotarySwitch = 2)
           THEN /\ lowBeamLeft = 100
                /\ lowBeamRight = 100
                /\ taillampleft = 100
                /\ taillampright = 100
           ELSE /\ lowBeamLeft >= 0
                /\ lowBeamRight >= 0
                /\ taillampleft >= 0
                /\ taillampright >= 0

\* testa se a els 39 é cumprida
prop_39 == IF brakePedal > 3 
           THEN brakeLight = 100
           ELSE IF brakePedal < 1
                THEN brakeLight = 0
                ELSE brakeLight = 100

\* testa se a els 40 é cumprida
prop_40 == IF brakePedal > 40 
           THEN brakeLight = 100
           ELSE IF brakePedal = 0 
                THEN brakeLight = 0
                ELSE brakeLight = 100

\* testa se as els 27 e 41 sao cumpridas
prop_27_41 == IF reverseGear = TRUE
              THEN /\ reverseLight = 100
                   /\ corneringLightLeft = 100
                   /\ corneringLightRight = 100
              ELSE /\ reverseLight = 0
                   /\ corneringLightLeft >= 0
                   /\ corneringLightRight >= 0
                   
\* testa se a els 24 é cumprida                   
prop_24 == IF (currentSpeed < 10 /\ (lowBeamLeft = 100 /\ lowBeamRight = 100 /\ taillampleft = 100 /\ taillampright = 100) /\ pitmanArmUpDown /= 0)
           THEN IF (pitmanArmUpDown = 1 \/ pitmanArmUpDown = 2)
                THEN corneringLightRight = 100
                ELSE corneringLightLeft = 100
           ELSE /\ corneringLightRight >= 0
                /\ corneringLightLeft >= 0


\*********************************************************\
\*                         Next                          *\
\*********************************************************\


Next == start \/
        blinkRight \/
        blinkLeft \/
        blinkTipLeft \/
        blinkTipRight \/
        hazardWarning \/
        hazardWarning_off \/
        neutralpitmanArmUpDown \/
        neutralpitmanArmForthBack \/
        pitmanArmForth \/
        pitmanArmManualBack \/
        liga_rotarySwitch \/
        ELS_15 \/
        ELS_16 \/
        ELS_18 \/
        darkness \/
        ELS_22 \/
        Adapt_HighBeam \/
        ELS_38 \/
        ELS_39 \/
        ELS_40 \/
        ELS_27_41 \/
        ELS_24 
        

        
=============================================================================
\* Modification History
\* Last modified Wed Jan 15 22:50:32 WET 2020 by sara
\* Last modified Mon Jan 13 16:19:45 WET 2020 by jnuno
\* Created Wed Dec 25 11:53:26 WET 2019 by jnuno