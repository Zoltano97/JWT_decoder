# JWT Dekóder GUI – PowerShell alapú segédprogram

Ez az alkalmazás egy egyszerű, grafikus felületű JWT (JSON Web Token) dekóder. A felhasználók bemásolhatnak egy JWT tokent, és az alkalmazás megjeleníti a token **Header** és **Payload** részét szöveges formában.

---

## 💻 Használat

1. Indítsd el a `jwt-dekoder.exe` fájlt dupla kattintással.
2. A megjelenő ablakban illeszd be a JWT tokenedet.
3. Kattints a **"Dekódolás"** gombra.
4. A dekódolt tartalom megjelenik alul:
   - `HEADER`: a token típusáról és algoritmusáról tartalmaz információt.
   - `PAYLOAD`: a hasznos adatokat tartalmazza (pl. felhasználó, jogosultságok, érvényesség).
5. A dekódolt adatokat:
   - **kimásolhatod a vágólapra**
   - **elmentheted szövegfájlba** (.txt)

---

## 📦 Tartalom

A csomag tartalmazza:
- `jwt-dekoder.exe` – a futtatható fájl
- `jwt-dekoder.ps1` – a PowerShell forráskód
- `README.md` – ez a leírás

---

## ⚙️ Rendszerkövetelmények

- Windows 10 / 11
- .NET Framework támogatás (alapból telepítve van)
- PowerShell 5.1 vagy újabb (csak ha a `.ps1` fájlt futtatnád)

---

## 🛠️ Fordítás `.exe`-vé saját magadnak

Ha a `jwt-dekoder.ps1` szkriptből saját `.exe`-t szeretnél készíteni:

1. Telepítsd a `PS2EXE` modult:
   ```powershell
   Install-Module -Name PS2EXE -Scope CurrentUser -Force
