# BPI-R4 Mesh WiFi 7 — Edición Customers (para Xiaomi_ax3600)

¡Hola amigo! 🍻 Algo para trastear. **Por favor, lee primero el aviso.**

Lo puedes probar **con lo que ya tienes**: tu **Pro 8X** y tu **BPI-R4 de 4GB**. Lo único que necesitas además son **dos tarjetas SD**, nada más.

## ⚠️ Antes de nada — importante
- Esto es una **«v1»** temprana de mi propio mesh WiFi 7 (wifimgr *Extender*). Mientras tanto me he movido a un proyecto más grande (**EasyMesh**), así que **esta v1 ya no la desarrollo** — te la mando **solo para probar/echar un vistazo**.
- Pruébala en **tarjetas SD limpias y de repuesto — no en tu router de diario.** Arrancas desde la SD; si no te convence, sacas la tarjeta → vuelves a tu sistema normal. **No tienes nada que perder, no vas a romper nada.**
- He recorrido todo el proceso paso a paso en hardware real (dos routers, un iPhone), así que no es un «a ver si funciona» — el mesh me arrancó, backhaul de ~2,9 Gbps, roaming funcionando. Aun así tómatelo como un juguete para curiosear, sin prisa.

> ⚠️ **Usa tarjetas SD de marca y de calidad.** Yo uso **SanDisk** y van bien. En cambio con las **Verbatim tuve mala experiencia — las mías acabaron en la basura** 😂. Las tarjetas malas/baratas se «graban sin error» en el programa de flasheo, **pero el router no arranca desde ellas** (fallo silencioso — la tarjeta miente sobre su capacidad). Parece un router estropeado, pero es solo la tarjeta. A mí mismo me hizo perder tiempo. 🙈

> 💡 **Consejo importante: usa nombres de red y contraseñas SENCILLOS.** Evita mezclar mayúsculas y minúsculas. Todo esto es **muy sensible** a las mayúsculas/minúsculas — a mí mismo se me coló un error por una sola letra y el mesh no montaba. Por eso en los ejemplos de abajo lo pongo todo en minúsculas.

---

## Qué obtienes — y cómo se verá

Montaremos un mesh con **dos routers**:
- **Router A = controlador** → Pro 8X (esta imagen customers, en la SD)
- **Router B = agente** → tu **Banana Pi R4 de 4GB** (imagen estándar + un par de paquetes)

**Aparecerán dos redes WiFi — y es a propósito:**
> - **`casamesh`** ← aquí conectas los móviles/portátiles. Esta red te **pasa sin cortes entre los dos routers** (roaming), así que al moverte por casa la conexión no se cae.
> - **`casawifi`** ← el **enlace privado entre los routers** (sustituye al cable, en 5 GHz). Aquí normalmente no conectas dispositivos; solo tiene que existir con nombre+contraseña para que el segundo router pueda «iniciar sesión» en el primero.

**Una cosa, para que no busques en vano:** absolutamente **todo** se configura en **wifimgr** — el mesh incluido. No busques en LuCI ningún ajuste antiguo de WiFi/roaming; en esta edición ni siquiera está. wifimgr es el único sitio que tocarás.

En el ejemplo de abajo uso nombres/contraseñas de muestra — **cámbialos por los tuyos** (recuerda: sencillos, todo en minúsculas), pero los valores marcados con *(igual que A)* déjalos idénticos en los dos routers.

| Qué | Valor de ejemplo |
|---|---|
| WiFi principal del Router A (= también el **backhaul**) | nombre `casawifi`, contraseña `clavecasa123` |
| **WiFi del mesh** para tus móviles | nombre `casamesh`, contraseña `clavemesh456` |

---

## PARTE 1 — Router A (controlador, Pro 8X, desde la SD limpia)

**1a) Graba y arranca**
- Graba la imagen customers para SD (`...-sdcard.img.gz`) en la tarjeta, arranca desde ella, abre LuCI: `http://192.168.1.1`.

**1b) Pon tu país (regulatorio)**
- wifimgr → **Radios** → **Country** → elige **`ES`** → Apply. El router se reiniciará.
- *(La imagen viene de fábrica en CZ — al cambiar a ES obtienes los canales/potencias correctos de España. Tus dispositivos se conectan igual, pero así queda conforme a la normativa.)*

**1c) Ponle nombre a la WiFi principal (servirá también de enlace entre routers)**
- wifimgr → **Networks** → en la red **`OpenWrt-MLD`** (marcada como *MLO AP*) pulsa editar:
  - nombre **`casawifi`**, contraseña **`clavecasa123`**
  - **Security → WPA3** ⚠️ *(tiene que ser WPA3, no WPA2/WPA3 — porque la red también va en 6 GHz, y 6 GHz prohíbe WPA2 por norma. Si dejas WPA2/WPA3, al aplicar te dará un error sobre «sae/owe».)*
  - Apply → el router se reiniciará.

**1d) Activa el controlador del mesh**
- wifimgr → **Mesh** → **Enable as Controller**:
  - **Mesh network name** = **`casamesh`**
  - **Mesh password** = **`clavemesh456`**
  - → **Enable**. **Espera un momento** (unos segundos, hace varios pasos) — aparecerá una barra naranja *«Reboot required»*. **No pulses otra vez.** → **Reboot now**.
- *(El formulario solo pide el nombre/contraseña del mesh — el enlace de 5 GHz sobre `casawifi` se activa solo.)*

Tras arrancar, la pestaña Mesh mostrará **Role: Controller**. También verás *«Backhaul: down»* y *«Connected agents (0)»* — **es normal**, aún no tienes el segundo router; en cuanto el agente aparezca, cambiará.

---

## PARTE 2 — Router B (agente, tu BPI-R4 de 4GB)

**2a) Graba la imagen estándar de 4GB**
- Del release **`release-4gb-standard`** graba **`...bpi-r4-sdcard.img.gz`** en una SD, arranca.
- Buena noticia: la imagen estándar de 4GB **ya sabe hacer WiFi 7 MLO** (trae el `wpad-openssl` correcto), así que solo hay que instalar dos cosas (abajo).

**2b) 🚨 PRIMERO cambia la dirección IP (¡si no, choca!)**
- El router recién grabado arranca también en `192.168.1.1` — **igual que el Router A** → colisión.
- Conéctate directamente al Router B, LuCI → cambia la **IP LAN a `192.168.1.2`** → Apply. Ahora lo tienes en `http://192.168.1.2`.

**2c) Instala los paquetes**

Necesitas dos: **`usteer`** y la versión nueva de **`luci-app-wifimgr` (4.0.0)**. `relayd` ya viene.

*La forma más cómoda — desde LuCI:* **System → Software** → instala **`usteer`** de la lista, y **sube** el `.apk` de `luci-app-wifimgr` (del release `release-pro-8x-customers`) con «Upload Package».

*Si prefieres la consola (SSH):*
```sh
cd /tmp
# --no-check-certificate es necesario: un router recién arrancado suele tener la
# hora mal (aún no ha sincronizado por NTP) y entonces el certificado parece
# "inválido". El fichero se descarga igual, no pasa nada.
wget --no-check-certificate https://github.com/woziwrt/bpi-r4-deploy/releases/download/release-pro-8x-customers/luci-app-wifimgr-4.0.0-r20260710.apk

# instalación local del fichero (--allow-untrusted porque es un .apk suelto)
apk add --allow-untrusted /tmp/luci-app-wifimgr-4.0.0-r20260710.apk

# usteer desde el repositorio (esto SÍ necesita la hora correcta;
# si falla por el certificado, espera un par de minutos a que el NTP
# ajuste la hora, o instálalo desde LuCI → System → Software)
apk add usteer
```

**2d) Reinicia el router** *(importante — tras instalar los paquetes, antes de configurar el mesh)*
- Reinicia / apaga y enciende. Así se carga la nueva versión de wifimgr desde cero (si no, el asistente del mesh podría dar errores raros).

**2e) Configúralo como agente**
- wifimgr → **Mesh** → **Enable as Agent**:
  - **Controller backhaul SSID** = **`casawifi`** ⚠️ *(escríbelo EXACTAMENTE igual que en el Router A. Es MUY sensible a mayúsculas/minúsculas — `casawifi` no es lo mismo que `Casawifi`. Es el error silencioso más típico: el mesh «no funciona y no sabes por qué». Por eso te decía de usar nombres sencillos en minúsculas.)*
  - **Backhaul key** = **`clavecasa123`** *(igual que A)*
  - **Controller BSSID** = *(déjalo vacío)*
  - **Mesh network name** = **`casamesh`** *(igual que A)*
  - **Mesh password** = **`clavemesh456`** *(igual que A)*
  - → **Enable**. **Espera tranquilamente 10+ segundos** (el agente hace más pasos que el controlador) a la barra naranja — **no pulses otra vez** → **Reboot now**.

**2f) 🚨 Cableado (para que no se forme un bucle)**
- **Router A (controlador):** conectado **solo a internet (WAN)**. Nada más por cable.
- **Entre los routers NO va ningún cable** — el segundo router se conecta al primero **únicamente por WiFi** (backhaul de 5 GHz). Un cable entre ellos crearía un bucle y tumbaría la red.
- Pon el agente en otra habitación; la alimentación + sus puertos LAN úsalos para clientes por cable si quieres, pero **ningún cable de vuelta al Router A.**

---

## PARTE 3 — Comprueba que funciona
1. **Router A → wifimgr → Mesh:** al cabo de ~1 minuto, bajo *«Connected agents»* aparece el **Router B** (MAC, señal, TX/RX). ✅
2. **Router B → wifimgr → Mesh:** muestra el **Controller** conectado (BSSID, señal). ✅
3. **Roaming (usteer)** en ambos = *running*. ✅
4. Conecta un móvil a **`casamesh`** y camina del Router A al Router B — debería pasar de uno a otro sin cortes. ✅

Si la PARTE 3 muestra todo ✅ → el mesh está en marcha. 🎉

---

## Notas y consejos
- **Reiniciar tras cada cambio de WiFi es normal** (el stack WiFi 7 / MLO necesita un reinicio completo).
- Junto a la WiFi principal quizá veas también las redes de fábrica `OpenWrt-2g/5g/6g` — puedes borrarlas en **Networks** para tener la lista de WiFi ordenada (opcional).
- Pequeña rareza de la interfaz: puede que **«Disable mesh»** tengas que pulsarlo **2 veces** para que salga el reinicio. No pasa nada.
- ¿Algún problema? Solo **saca la SD** → vuelves al instante a tu sistema normal.

### ¿Por qué el backhaul va en 5 GHz y no en 6 GHz?
El backhaul (el enlace entre routers) va en **5 GHz** — y es a propósito. **6 GHz** tiene mayor velocidad punta, pero **bastante peor alcance y penetración por las paredes** (más atenuación con la frecuencia + menor potencia permitida en interior). Entre habitaciones, un enlace en 6 GHz sería poco fiable. 5 GHz = mejor alcance y fiabilidad, y aun así mueve ~2,5 Gbps. **Tus dispositivos sí usan 6 GHz** — la red `casamesh` emite en 6 GHz y el móvil se engancha ahí (en mi prueba ~1,8 Gbps). Así que «6 GHz te funciona», solo que el enlace entre routers es 5 GHz a propósito.

Un mesh nativo en 6 GHz como es debido lo estoy preparando en EasyMesh — y **serás el primero en tenerlo.** 😉

Un abrazo, y disfruta trasteando. 🍻
Petr
