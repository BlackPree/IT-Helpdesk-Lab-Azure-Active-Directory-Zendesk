# 🖥️ IT Helpdesk Lab — Azure Active Directory + Zendesk

### Built by: Munashe
### LinkedIn: [linkedin.com/in/yourprofile](https://linkedin.com/in/yourprofile)
### GitHub: [github.com/yourusername](https://github.com/yourusername)

---

<div align="center">

![Azure](https://img.shields.io/badge/Azure-Free_Tier-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)
![Windows Server](https://img.shields.io/badge/Windows_Server-2022-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![Zendesk](https://img.shields.io/badge/Zendesk-ITSM-03363D?style=for-the-badge&logo=zendesk&logoColor=white)
![Cost](https://img.shields.io/badge/Total_Cost-$0.00-brightgreen?style=for-the-badge)

</div>

---

## 📌 About This Project

A fully functional IT Helpdesk environment built on **Microsoft Azure** using only free-tier resources. It simulates the real daily workflow of a **Level 1 / Level 2 IT Support** role — managing users in Active Directory, automating tasks with PowerShell, and handling tickets end-to-end in Zendesk.

**Everything in this lab was built hands-on, documented step by step, and cost $0.**

---

## 🏗️ Architecture

```
┌──────────────────────────────────────────────────────┐
│               MICROSOFT AZURE (Free Tier)             │
│                                                      │
│  ┌────────────────────────┐  ┌──────────────────┐    │
│  │  DC01                  │  │  CLIENT01        │    │
│  │  Windows Server 2022   │  │  Windows 10      │    │
│  │  Standard_B1s (FREE)   │  │  Standard_B1s    │    │
│  │                        │  │  (FREE)          │    │
│  │  • AD Domain Services  │  │                  │    │
│  │  • DNS Server          │  │  Domain-joined   │    │
│  │  • PowerShell Scripts  │  │  workstation     │    │
│  │                        │  │                  │    │
│  │  Domain: helpdesk.local│  │                  │    │
│  └────────────────────────┘  └──────────────────┘    │
│                                                      │
│  Resource Group : helpdesk-lab-rg                    │
│  Virtual Network: helpdesk-vnet (10.0.0.0/16)        │
│  Region         : South India                        │
└──────────────────────────────────────────────────────┘
                        │
                        │ Tickets link to AD actions
                        ▼
        ┌───────────────────────────────┐
        │  Zendesk (Cloud — Free Trial) │
        │                               │
        │  • 4 Ticket Forms             │
        │  • 2 SLA Policies             │
        │  • 3 Response Macros          │
        │  • 2 Agent Groups             │
        │  • Knowledge Base (SOPs)      │
        └───────────────────────────────┘
```

---

## 📁 Repository Structure

```
it-helpdesk-lab/
│
├── README.md                          ← This file
├── DOCUMENTATION.md                   ← Full setup guide and project write-up
├── .gitignore                         ← Keeps secrets out of GitHub
├── START-HERE.md                      ← Plain English build order for beginners
│
├── docs/
│   ├── 01-azure-setup.md              ← Azure VMs, NSG, RDP
│   ├── 02-active-directory.md         ← DC setup, OUs, users, GPO, domain join
│   ├── 03-powershell-scripts.md       ← All 4 scripts explained with examples
│   ├── 04-zendesk-setup.md            ← Ticket forms, SLAs, macros, agent groups
│   └── 05-scenarios.md                ← 4 end-to-end helpdesk simulations
│
├── scripts/
│   ├── New-HelpdeskUser.ps1           ← Create new AD user
│   ├── Set-HelpdeskUser.ps1           ← Modify existing AD user
│   ├── Remove-HelpdeskUser.ps1        ← Offboard / disable user
│   └── Reset-HelpdeskPassword.ps1     ← Password reset workflow
│
├── sops/
│   ├── SOP-HD-001-Password-Reset.md
│   ├── SOP-HD-002-Account-Unlock.md
│   ├── SOP-HD-003-New-User.md
│   └── SOP-HD-004-Offboarding.md
│
├── configs/
│   └── nsg-rules.md                   ← Azure firewall rules reference
│
└── assets/                            ← Screenshots (add as you build)
```

---

## ⚡ Scripts Summary

| Script | Command | What it does |
|---|---|---|
| `New-HelpdeskUser.ps1` | `.\New-HelpdeskUser.ps1 -First "Jane" -Last "Doe" -Dept "Finance" -Title "Analyst"` | Creates AD user, auto-generates username |
| `Set-HelpdeskUser.ps1` | `.\Set-HelpdeskUser.ps1 -Username "jdoe" -NewTitle "Senior Analyst"` | Updates user attributes |
| `Remove-HelpdeskUser.ps1` | `.\Remove-HelpdeskUser.ps1 -Username "jdoe" -TicketID "2089"` | Disables, strips access, archives |
| `Reset-HelpdeskPassword.ps1` | `.\Reset-HelpdeskPassword.ps1 -Username "jdoe" -TicketID "1042"` | Resets password, unlocks account |

---

## 🎫 Zendesk Ticket Forms

| Form | Assigned Group | SLA |
|---|---|---|
| Password Reset | L1 Helpdesk | 2 hours |
| Account Unlock | L1 Helpdesk | 2 hours |
| New User Setup | L2 Sysadmin | 1 business day |
| Account Termination | L2 Sysadmin | 4 hours |

---

## 🛠️ Skills Demonstrated

- Azure VM provisioning (Resource Groups, VNets, NSGs)
- Windows Server 2022 administration
- Active Directory — domain setup, OUs, user lifecycle, GPO
- PowerShell scripting with the ActiveDirectory module
- ITSM ticketing with Zendesk (forms, SLAs, macros, knowledge base)
- Least-privilege network security (NSG rules)
- Technical SOP writing and documentation

---

## 💰 Cost: $0

| Resource | Free Allowance | Used |
|---|---|---|
| Azure Standard_B1s VMs | 750 hrs/month × 12 months | ~100 hrs total |
| Zendesk | 14-day free trial | Used in Phase 4–5 |

> **Stop your VMs after every session** → Azure portal → VM → Stop (must say "deallocated")

---

## 📖 Setup Order

1. [Azure Setup →](docs/01-azure-setup.md)
2. [Active Directory →](docs/02-active-directory.md)
3. [PowerShell Scripts →](docs/03-powershell-scripts.md)
4. [Zendesk Setup →](docs/04-zendesk-setup.md)
5. [Helpdesk Scenarios →](docs/05-scenarios.md)

---

*Built by Munashe — Azure AD + Zendesk helpdesk lab. Zero cost, fully documented, hands-on.*
