# Phase 4 — Zendesk Setup

**Goal:** Configure your existing Zendesk account as a production-style helpdesk with ticket forms, SLA policies, macros, and agent groups.

**Time:** ~2 hours | **Cost:** Free (14-day trial)  
**Prerequisites:** [Phase 3 complete](03-powershell-scripts.md) — all 4 PowerShell scripts working on DC01

> ⏰ **Start this now — your 14-day trial clock begins from when you first log in and configure things.**

---

## Table of Contents
- [Initial Configuration](#initial-configuration)
- [Create Agent Groups](#create-agent-groups)
- [Create Ticket Forms](#create-ticket-forms)
- [Configure SLA Policies](#configure-sla-policies)
- [Create Macros](#create-macros)
- [Test the Setup](#test-the-setup)
- [Verification Checklist](#verification-checklist)

---

## Initial Configuration

Log into your Zendesk admin panel:
```
https://[your-subdomain].zendesk.com/admin
```

### Business Hours

**Admin Centre → Objects and rules → Business hours → Add schedule**

| Setting | Value |
|---|---|
| Schedule name | `Standard Business Hours` |
| Days | Monday – Friday |
| Hours | 09:00 – 17:00 |
| Time zone | Your local time zone (CAT — Central Africa Time) |

### Branding

**Admin Centre → Account → Branding**

| Setting | Value |
|---|---|
| Help center name | `Helpdesk Lab Support` |
| Company name | `Helpdesk Lab` |

---

## Create Agent Groups

Groups automatically route tickets to the right team.

**Admin Centre → People → Groups → Create group**

| Group | Purpose |
|---|---|
| `L1 Helpdesk` | First-line — password resets, unlocks, basic requests |
| `L2 Sysadmin` | Escalation — new accounts, offboarding, AD changes |

Add yourself to **both groups** so you can process all ticket types.

---

## Create Ticket Forms

Ticket forms control what information a user fills in when submitting a request.

**Admin Centre → Objects and rules → Tickets → Forms → Add form**

---

### Form 1 — Password Reset

**Form name:** `Password Reset`  
**End-user label:** `I can't log in / need a password reset`  
**Default group:** L1 Helpdesk

Fields to add:

| Field | Type | Required |
|---|---|---|
| Subject | Text (default) | Yes |
| Description | Text area (default) | Yes |
| Employee Username | Text (create custom) | Yes |
| Employee ID | Number (create custom) | Yes |

---

### Form 2 — Account Unlock

**Form name:** `Account Unlock`  
**End-user label:** `My account is locked`  
**Default group:** L1 Helpdesk

Fields to add:

| Field | Type | Required |
|---|---|---|
| Subject | Text | Yes |
| Description | Text area | Yes |
| Employee Username | Text | Yes |

---

### Form 3 — New User Setup

**Form name:** `New User Setup`  
**End-user label:** `Request a new employee account`  
**Default group:** L2 Sysadmin

Fields to add:

| Field | Type | Required |
|---|---|---|
| Subject | Text | Yes |
| Description | Text area | Yes |
| New Employee Full Name | Text (create custom) | Yes |
| Department | Dropdown (create custom) — options: IT, HR, Finance, Helpdesk | Yes |
| Manager Name | Text (create custom) | Yes |
| Start Date | Date (create custom) | Yes |
| Job Title | Text (create custom) | Yes |

---

### Form 4 — Account Termination

**Form name:** `Account Termination`  
**End-user label:** `Employee account closure`  
**Default group:** L2 Sysadmin

Fields to add:

| Field | Type | Required |
|---|---|---|
| Subject | Text | Yes |
| Description | Text area | Yes |
| Employee Username | Text | Yes |
| Employee Full Name | Text | Yes |
| Last Working Day | Date | Yes |
| Manager Name | Text | Yes |

---

## Configure SLA Policies

SLAs define how quickly tickets must be responded to and resolved.

**Admin Centre → Objects and rules → Business rules → Service level agreements → Add policy**

---

### SLA 1 — Urgent (Account Access)

| Setting | Value |
|---|---|
| Policy name | `Urgent — Account Access` |
| Conditions | Form is Password Reset OR Account Unlock |
| First reply time | 30 minutes |
| Resolution time | 2 hours |
| Hours | Business hours |

---

### SLA 2 — Standard (User Management)

| Setting | Value |
|---|---|
| Policy name | `Standard — User Management` |
| Conditions | Form is New User Setup OR Account Termination |
| First reply time | 4 hours |
| Resolution time | 1 business day |
| Hours | Business hours |

---

## Create Macros

Macros are one-click response templates so you don't retype the same reply every ticket.

**Admin Centre → Workspaces → Agent tools → Macros → Add macro**

---

### Macro 1 — Password Reset Sent

**Name:** `Password Reset — Temp Password Sent`

Action — set ticket comment to:
```
Hi {{ticket.requester.first_name}},

Your password has been reset. Your temporary password is:

[INSERT TEMP PASSWORD — TempPass@1!]

Please log in now. You will be immediately asked to set a new permanent password.
Do not share this temporary password with anyone.

Reply to this ticket once you have successfully logged in.

IT Helpdesk
```

Action — set ticket status to: **Pending**

---

### Macro 2 — Awaiting Confirmation

**Name:** `Resolved — Awaiting User Confirmation`

Action — set ticket comment to:
```
Hi {{ticket.requester.first_name}},

We've completed the action on your account. Please confirm everything is working.

If we don't hear back within 24 hours, this ticket will be marked as Solved.

IT Helpdesk
```

Action — set ticket status to: **Pending**

---

### Macro 3 — Offboarding Complete

**Name:** `Offboarding — Account Disabled`

Action — set ticket comment to:
```
Hi {{ticket.requester.first_name}},

The following has been completed for [EMPLOYEE NAME]:

✅ Active Directory account disabled
✅ All group memberships removed
✅ Account archived in Disabled_Users OU

The account will be held for 30 days before permanent deletion.

IT Helpdesk
```

Action — set ticket status to: **Solved**

---

## Test the Setup

1. Open a new **incognito / private browser window**
2. Go to: `https://[your-subdomain].zendesk.com`
3. Submit a test ticket:
   - Form: **Password Reset**
   - Username: `jsmith`
   - Employee ID: `11001`
   - Description: `I can't log into my computer`
4. In your main browser (logged in as agent):
   - Go to **Views → All unsolved tickets**
   - Confirm: the ticket is there, assigned to L1 Helpdesk, SLA countdown is running
5. Click the ticket → apply macro: **Password Reset — Temp Password Sent**
6. Set to **Solved**

If that works — your Zendesk is fully configured.

---

## Verification Checklist

- [ ] Business hours set (Mon–Fri, correct time zone)
- [ ] Branding updated
- [ ] Two agent groups: L1 Helpdesk, L2 Sysadmin
- [ ] Four ticket forms created with correct fields
- [ ] Two SLA policies active
- [ ] Three macros created
- [ ] Test ticket submitted, received, and resolved

---

**Next:** [Phase 5 — Helpdesk Scenarios →](05-scenarios.md)
