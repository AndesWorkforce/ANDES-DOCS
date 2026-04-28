# Video Tutorial Script - Holidays Management System

**Feature:** KAN-40 - Calendar Bonifications  
**Estimated Duration:** 5-7 minutes  
**Date:** February 2026

---

## Video Structure

### Introduction (30 seconds)
### Part 1: Admin - Holidays Management (2-3 minutes)
### Part 2: User - Holidays Viewing (1-2 minutes)
### Closing (30 seconds)

---

## INTRODUCTION (30 seconds)

**[Screen: Andes Workforce Logo]**

**Narrator:**
> "Welcome to this tutorial on the new holidays management feature in Andes Workforce. In this video, you'll learn how to manage the holidays calendar by country and how users can view this information."

---

## PART 1: SUPERADMIN ROLE - HOLIDAYS MANAGEMENT (2-3 minutes)

### Scene 1.1: Module Access (20 seconds)

> "As a SuperAdmin, we navigate to the Settings module in the sidebar and click on 'Holidays Calendar'."

### Scene 1.2: Calendar Visualization (30 seconds)

> "This is the main view of the holidays manager. Here we can see all holidays organized by country. Each country is grouped and can be expanded or collapsed by clicking on the blue bar."

> "Notice that each holiday shows its name, day, and month. The months are displayed in English to maintain consistency throughout the application."

### Scene 1.3: Filtering and Search (30 seconds)

> "We can filter holidays using the search bar or country filters to show only holidays from specific countries."

### Scene 1.4: Creating a Holiday (45 seconds)

> "To add a new holiday, click the 'Add Holiday' button. A form will open where we fill in: holiday name, day, month, and country."

**Example:** Holiday Name: "Test Day" | Day: 15 | Month: March | Country: Colombia

> "Once completed, click 'Create' and we'll see a success notification."

### Scene 1.5: Edit and Delete (45 seconds)

> "To edit an existing holiday, click the edit icon. To delete, click the trash icon — confirmation will be requested to prevent accidental deletions."

---

## PART 2: USER ROLE - HOLIDAYS VIEWING (1-2 minutes)

### Scene 2.1: Access to Bonifications

> "Contractors can view their country's holidays directly on the bonifications page."

### Scene 2.2: Bonifications View

> "From the navbar, we navigate to 'Bonifications'. On this page, in addition to bonuses and incentives information, we find a holidays section."

### Scene 2.3: User's Holiday Calendar

> "Here we see the holidays calendar specific to Colombia. The table shows the country name, current year, and all holidays. Each holiday shows the date in a readable format and the name in English."

### Scene 2.4: Different Scenarios

- **Not authenticated:** message "Login to see holidays"
- **No country configured:** message "Complete your profile"
- **Country without holidays loaded:** informative message

---

## CLOSING (30 seconds)

> "In summary, we've seen how SuperAdmins can manage the complete holidays calendar for multiple countries, and how users can easily check their country's holidays on the bonifications page."

**Key points:**
- ✅ Centralized holidays management by country
- ✅ Intuitive interface for CRUD operations
- ✅ Automatic display based on user's country
- ✅ Always up-to-date information

---

## PRODUCTION NOTES

**Required test data:**
- Database with loaded holidays (Colombia, Mexico, Argentina)
- SuperAdmin user: `admin@test.com`
- Contractor user (country: Colombia): `contractor@test.com`
- User without country: `contractor2@test.com`

**Recording configuration:**
- Resolution: 1920x1080 | FPS: 30/60 | Format: MP4 | Codec: H.264

**Key points to highlight in editing:**
- Zoom on important elements
- Circles or arrows to guide attention
- Subtitles in Spanish and English
- Soft background music (optional)

**Maximum duration:** 7 minutes total
