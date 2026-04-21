# START HERE — Munashe's Azure + Zendesk Helpdesk Lab
## Plain English, Day by Day

---

## What You're Building

```
Azure VM (DC01)          +        Zendesk (Cloud)
────────────────                  ───────────────
Windows Server 2022               Ticketing system
Active Directory                  Users submit tickets here
PowerShell scripts                You process them using
Domain: helpdesk.local            PowerShell on DC01
```

**Cost: $0 | Time: ~2 weeks part-time (1–2 hrs/day)**

---

## Accounts You Already Have ✅

- Azure account → portal.azure.com ✅
- Zendesk account → your-subdomain.zendesk.com ✅

**Don't start using Zendesk yet** — begin it only on Day 8. The free trial is 14 days so you want to start it when you're actually ready to use it.

---

## Your Build Order

---

### WEEK 1 — Azure & Active Directory

**Day 1 — Connect to DC01**
→ Guide: `docs/01-azure-setup.md`
- Confirm DC01 is running in Azure portal
- Get DC01's public IP (changes every restart — always check)
- RDP in as `Azureserver` with your password
- Confirm you're inside the server

**Day 2 — Set static IP + Install AD**
→ Guide: `docs/02-active-directory.md` (Part 1)
- Set DC01's private IP as static (required before AD setup)
- Open Server Manager → Add Roles → install Active Directory Domain Services
- Takes about 5 minutes to install

**Day 3 — Promote to Domain Controller**
→ Guide: `docs/02-active-directory.md` (Part 2)
- Click the yellow flag in Server Manager → Promote this server
- Domain name: `helpdesk.local`
- Server restarts automatically
- Log back in as `HELPDESK\Azureserver`

**Day 4 — Build your AD structure**
→ Guide: `docs/02-active-directory.md` (Part 3)
- Open Active Directory Users and Computers
- Create 5 OUs: IT, HR, Finance, Helpdesk, Disabled_Users
- Create 10 test users manually (list is in the guide)
- Configure Group Policy (password rules, account lockout)

**Day 5 — Join CLIENT01 + test**
→ Guide: `docs/02-active-directory.md` (Part 4)
- RDP into CLIENT01 separately
- Point its DNS to DC01's private IP
- Join CLIENT01 to helpdesk.local domain
- Log into CLIENT01 as a domain user to confirm it works

---

### WEEK 2 — Scripts + Zendesk + Scenarios

**Day 6 — Deploy PowerShell scripts**
→ Guide: `docs/03-powershell-scripts.md`
- On DC01: create `C:\Scripts\` folder
- Copy the 4 scripts from this repo into that folder
- Test each one — create a test user, reset a password, offboard them

**Day 7 — Buffer / catch-up day**
- Fix anything that didn't work in Week 1
- Take screenshots of what's working

**Day 8 — Start Zendesk NOW (14-day clock starts)**
→ Guide: `docs/04-zendesk-setup.md`
- Log into your Zendesk account
- Configure business hours, branding
- Create 2 agent groups (L1 Helpdesk, L2 Sysadmin)
- Create 4 ticket forms
- Set up SLA policies and macros

**Day 9–10 — Run the 4 helpdesk scenarios**
→ Guide: `docs/05-scenarios.md`
- Scenario 1: Password reset (Zendesk ticket → PowerShell → close ticket)
- Scenario 2: New employee onboarding
- Scenario 3: Offboarding
- Scenario 4: Publish a knowledge base SOP article in Zendesk

**Day 11–12 — Document and upload to GitHub**
- Take all remaining screenshots
- Upload everything to your GitHub repo (see path below)
- Add your LinkedIn to README.md
- Pin repo to your GitHub profile

---

## The One Rule That Keeps This Free

**Stop DC01 and CLIENT01 after every session.**

Azure portal → click the VM → click **Stop** → wait for status: **Stopped (deallocated)**

"Stopped" alone still charges you. Must say **deallocated**.

When you come back: VM → **Start** → wait 2 minutes → check the new public IP → RDP in.

---

## GitHub Upload Path

Create your repo with this exact structure:

```
it-helpdesk-lab/               ← your repo name
│
├── README.md                  ← upload to root
├── DOCUMENTATION.md           ← upload to root
├── START-HERE.md              ← upload to root
├── .gitignore                 ← upload to root
│
├── docs/                      ← type "docs/" before each filename
│   ├── 01-azure-setup.md
│   ├── 02-active-directory.md
│   ├── 03-powershell-scripts.md
│   ├── 04-zendesk-setup.md
│   └── 05-scenarios.md
│
├── scripts/                   ← type "scripts/" before each filename
│   ├── New-HelpdeskUser.ps1
│   ├── Set-HelpdeskUser.ps1
│   ├── Remove-HelpdeskUser.ps1
│   └── Reset-HelpdeskPassword.ps1
│
├── sops/                      ← type "sops/" before each filename
│   ├── SOP-HD-001-Password-Reset.md
│   ├── SOP-HD-002-Account-Unlock.md
│   ├── SOP-HD-003-New-User.md
│   └── SOP-HD-004-Offboarding.md
│
├── configs/
│   └── nsg-rules.md
│
└── assets/                    ← drag and drop screenshots here
    ├── azure-dc01-running.png
    ├── ad-ous.png
    ├── ad-users.png
    ├── ps-new-user-output.png
    ├── ps-password-reset-output.png
    ├── zendesk-ticket-forms.png
    ├── zendesk-solved-ticket.png
    └── zendesk-kb-article.png
```

**How to upload on GitHub (no software needed):**
1. Go to your repo → **Add file → Create new file**
2. In the name box type the full path e.g. `docs/01-azure-setup.md`
3. Paste the file contents into the text area
4. Scroll down → write a commit message → **Commit changes**
5. Repeat for every file

For screenshots: **Add file → Upload files** → drag images in → type `assets/` before the filename.

---

## What NOT to Put on GitHub

| Never upload | Why |
|---|---|
| `.pem` or `.ppk` key files | Anyone who gets this owns your server |
| Passwords anywhere in files | Remove before committing |
| Your Azure VM admin password | Never write this in any file |
| Personal info beyond your name | Phone, address, ID numbers |

The `.gitignore` file in this repo already blocks the most dangerous files automatically.
