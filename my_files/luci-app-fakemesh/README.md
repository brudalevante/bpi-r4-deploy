English translation:

Fakemesh Introduction
fakemesh is a network topology structure composed of a controller (AC), one or more wired APs (Wired AP), and satellites (Agent). It is a hybrid network combining Wireless Mesh and AC+AP networking modes. In this setup, the wired APs connect to the controller (AC) via cables, while the satellites (Agent) connect wirelessly using the STA method, forming a wireless (including wired) coverage network.

Deploying fakemesh is relatively convenient. You only need to connect the node devices to the correct network and configure the roles, Mesh ID, and other necessary information. Since fakemesh combines Wireless Mesh and AC+AP modes, it is also easy to implement hybrid networks, increasing both coverage and reliability.

Currently, X-WRT has fakemesh functionality integrated by default.

Using fakemesh
Device access addresses after successful network configuration: Access the controller: http://controller.fakemesh/ or http://ac.fakemesh/

Access the APs: http://{mac}.ap.fakemesh/ or http://N.ap.fakemesh/

Where {mac} is the MAC address of the AP, for example: {mac}=1122334455AB. N is the automatically assigned AP number, for example: N=1, N=2, N=3, ...

Examples:

Code http://1.ap.fakemesh/ http://1122334455AB.ap.fakemesh/ Troubleshooting: If an AP is offline for about 3 minutes, it will enter failure mode. In this mode, a default SSID is enabled to allow management access for reconfiguration.

The default SSID and password in failure mode are:

Code SSID: X-WRT_XXXX PASSWD: 88888888 In failure mode, the AP’s management IP address is the gateway address provided by DHCP. For example, if your computer obtains an IP like 192.168.16.x, then the AP’s management IP will be 192.168.16.1.

Fakemesh Basic Components
The network includes a controller (controller) and one or more APs.

APs include: satellites (Agent) and wired APs (Wired AP).

Controller: Acts as the AC and outbound router, providing internet access, managing satellite and wired APs, and centralizing wireless management. Satellites: APs connected via Wi-Fi. Wired APs: APs connected via cable.

Fakemesh Configuration Parameters
Mesh ID: This parameter is the common ID for a fakemesh network. The controller, satellites, and wired APs must share the same Mesh ID.

Key: This is the common encryption key for the network. If encryption is not required, this can be left blank.

Band: The wireless frequency band used in the network. This must be set consistently (5G or 2G) across all devices.

Role: Can be Controller, Satellite, or Wired AP.

Sync Configuration: Determines whether the controller will centrally manage Wi-Fi settings for the entire network.

Access IP Address: Assigns a specific IP address to access the controller’s management interface.

Fronthaul Disabled: Disables wireless signal retransmission, preventing other APs from connecting through this node.

Band Steer Helper: You can choose DAWN or usteer for roaming assistance.

Wireless Management
From the controller interface, you can centrally manage wireless settings, including adding/removing SSIDs, setting SSID encryption, and adjusting bandwidth.

Controller Bypass Deployment
If the controller does not act as a gateway nor provides DHCP service, the user must configure the network settings manually, including the LAN interface IP, gateway IP, and DNS. Additionally, the controller's LAN interface usually defaults to DHCP client mode to obtain an IP from a third-party gateway. If a static IP is required, ensure the controller and the third-party gateway exist within the same subnet and can communicate with each other. Otherwise, synchronization between the controller and other APs will fail.

traducion al español

Introducción a fakemesh
fakemesh es una estructura de topología de red compuesta por un controlador (AC), uno o más AP cableados (Wired AP) y satélites (Agent). Es una red híbrida que combina los modos de red Wireless Mesh y AC+AP. En esta configuración, los AP cableados se conectan al controlador (AC) mediante cables, mientras que los satélites (Agent) se conectan de forma inalámbrica utilizando el modo STA, formando así una red de cobertura inalámbrica (que también incluye cableada).

El despliegue de fakemesh es relativamente sencillo: solo necesitas conectar los dispositivos nodos a la red correcta y configurar el rol, Mesh ID y otra información relevante en cada nodo. Gracias a que fakemesh combina las redes Wireless Mesh y AC+AP, también es fácil implementar redes híbridas que mejoren la cobertura y la confiabilidad de la red.

Actualmente, X-WRT integra fakemesh de manera predeterminada.

Uso de fakemesh
Formatos de dirección para acceder a los dispositivos después de configurar la red: Dirección para acceder al controlador: http://controller.fakemesh/ o http://ac.fakemesh/

Dirección para acceder a los AP: http://{mac}.ap.fakemesh/ o http://N.ap.fakemesh/

Donde {mac} corresponde a la dirección MAC del AP, por ejemplo: {mac}=1122334455AB. Y N es el número asignado automáticamente al AP, por ejemplo: N=1, N=2, N=3, ...

Ejemplos:

Code http://1.ap.fakemesh/ http://1122334455AB.ap.fakemesh/ Solución de problemas: Si un AP permanece desconectado durante aproximadamente 3 minutos, entrará en modo de fallo. En este modo, se habilitará un SSID predeterminado que permite acceder para reconfigurar el dispositivo.

El SSID y contraseña predeterminados en modo de fallo son:

Code SSID: X-WRT_XXXX PASSWD: 88888888 En este modo, la dirección IP de gestión del AP será la dirección de la puerta de enlace DHCP. Por ejemplo, si un ordenador obtiene una IP 192.168.16.x, la IP de gestión del AP será 192.168.16.1.

Componentes básicos de fakemesh
La red incluye un controlador (controller) y uno o más AP.

Los AP se dividen en: satélites (Agent) y AP cableados (Wired AP).

Controlador (Controller): Actúa como el AC y router de salida, proporcionando acceso a Internet, gestionando los satélites y AP cableados, y unificando la gestión inalámbrica. Satélites (Agent): AP conectados mediante Wi-Fi. AP cableados (Wired AP): AP conectados mediante cables.

Parámetros de configuración de fakemesh
Mesh ID: Este parámetro es el identificador común de la red fakemesh. El controlador, los satélites y los AP cableados deben configurarse con el mismo Mesh ID.

Clave (Key): Es la clave de encriptación común utilizada en la red. Si no se requiere encriptación, se puede dejar en blanco.

Banda (Band): Es la banda inalámbrica utilizada para la red, y debe ser la misma (5G o 2G) en todos los dispositivos.

Rol (Role): Puede ser Controlador, Satélite o AP cableado.

Configuración sincronizada (Sync Config): Permite centralizar la configuración Wi-Fi a través del controlador.

Dirección IP de acceso (Access IP address): Configura una IP específica para acceder a la interfaz de gestión del controlador.

Deshabilitar retransmisión (Fronthaul Disabled): Desactiva la retransmisión de señales inalámbricas desde este nodo, evitando que otros AP se conecten a través de él.

Ayudante de itinerancia (Band Steer Helper): Actualmente, se puede elegir entre DAWN o usteer como asistente de itinerancia.

Gestión inalámbrica (Wireless Management)
A través de la interfaz del controlador, se pueden gestionar centralizadamente las redes inalámbricas, como agregar/quitar SSIDs, configurar encriptación y ajustar el ancho de banda.

Despliegue en modo alternativo del controlador
Cuando el controlador no actúa como puerta de enlace ni proporciona servicios DHCP, los usuarios deben configurar manualmente la red, incluyendo la IP de la interfaz LAN, la IP de la puerta de enlace y el DNS. Generalmente, la interfaz LAN del controlador está configurada por defecto como cliente DHCP para obtener una IP desde una pasarela de terceros. Si se requiere IP estática, debes asegurarte de que el controlador y la pasarela están en la misma subred y que pueden comunicarse. De lo contrario, la configuración sincronizada entre el controlador y los AP no funcionará.

