# Video Tutorial Script - Holidays Management System
**Feature:** KAN-40 - Calendar Bonifications  
**Estimated Duration:** 5-7 minutes  
**Date:** February 2026

---

## 📋 Video Structure

### Introduction (30 seconds)
### Part 1: Admin - Holidays Management (2-3 minutes)
### Part 2: User - Holidays Viewing (1-2 minutes)
### Closing (30 seconds)

---

## 🎬 DETAILED SCRIPT

### INTRODUCTION (30 seconds)

**[Screen: Andes Workforce Logo]**

**Narrator:**
> "Welcome to this tutorial on the new holidays management feature in Andes Workforce. In this video, you'll learn how to manage the holidays calendar by country and how users can view this information."

**[Transition: Fade to dashboard]**

---

## PART 1: SUPERADMIN ROLE - HOLIDAYS MANAGEMENT (2-3 minutes)

### Scene 1.1: Module Access (20 seconds)

**[Screen: Login as SuperAdmin]**

**Narrator:**
> "As a SuperAdmin, we first log into the platform."

**On-screen actions:**
- Login with admin credentials
- Redirect to dashboard

**[Screen: Module navigation]**

**Narrator:**
> "We navigate to the Settings module in the sidebar and click on 'Holidays Calendar'."

**On-screen actions:**
- Click on sidebar → Settings
- Scroll to see "Holidays Calendar"
- Click on the option

---

### Scene 1.2: Calendar Visualization (30 seconds)

**[Screen: HolidaysManager View]**

**Narrator:**
> "This is the main view of the holidays manager. Here we can see all holidays organized by country. Each country is grouped and can be expanded or collapsed by clicking on the blue bar."

**On-screen actions:**
- Show complete table
- Highlight grouped countries (Colombia, Mexico, Argentina)
- Expand/collapse a country to demonstrate

**Narrator:**
> "Notice that each holiday shows its name, day, and month. The months are displayed in English to maintain consistency throughout the application."

**On-screen actions:**
- Zoom in on a holiday row
- Highlight columns: Holiday Name, Day, Month

---

### Scene 1.3: Filtering and Search (30 seconds)

**[Screen: Filters section]**

**Narrator:**
> "We can filter holidays in two ways: using the search bar to search by name or date, and using country filters to show only holidays from specific countries."

**On-screen actions:**
- Type in search bar: "Independence"
- View filtered results
- Clear search
- Click on "Colombia" filter
- Show only Colombia's holidays
- Click "All" to view all

---

### Scene 1.4: Creating a Holiday (45 seconds)

**[Screen: Creation Modal]**

**Narrator:**
> "To add a new holiday, we click the 'Add Holiday' button. A form will open where we need to complete the information."

**On-screen actions:**
- Click "Add Holiday" button
- Modal opens

**Narrator:**
> "We fill in the required fields: holiday name, day, month, and country. For example, let's create a test holiday."

**On-screen actions:**
- Holiday Name: "Test Day"
- Day: select "15"
- Month: select "March"
- Country: select "Colombia"
- Pause to show complete form

**Narrator:**
> "Once completed, we click 'Create' and we'll see a success notification."

**On-screen actions:**
- Click "Create" button
- Show green success notification
- See new holiday in the table

---

### Scene 1.5: Edit and Delete (45 seconds)

**[Screen: Table actions]**

**Narrator:**
> "To edit an existing holiday, we simply click the edit icon. This will open the same form but with the data preloaded."

**On-screen actions:**
- Hover over Edit icon (blue pencil)
- Click on Edit
- Modal opens with data
- Change name to "Test Day Edited"
- Click "Update"
- Show success notification

**Narrator:**
> "If we need to delete a holiday, we click the trash icon. We'll be asked for confirmation to prevent accidental deletions."

**On-screen actions:**
- Click on Delete icon (red trash can)
- Confirmation modal appears
- Highlight warning message
- Click "Delete"
- Show success notification
- Holiday disappears from table

---

## PART 2: USER ROLE - HOLIDAYS VIEWING (1-2 minutes)

### Scene 2.1: Access to Bonifications (15 seconds)

**[Screen: Login as user/contractor]**

**Narrator:**
> "Now let's see the experience from a user's point of view. Contractors can view their country's holidays directly on the bonifications page."

**On-screen actions:**
- Logout from admin
- Login with contractor user (configured country: Colombia)

---

### Scene 2.2: Bonifications View (20 seconds)

**[Screen: Navigation to bonifications]**

**Narrator:**
> "From the navbar, we navigate to 'Bonifications'."

**On-screen actions:**
- Click on "Bonifications" link in navbar
- Page loads

**Narrator:**
> "On this page, in addition to bonuses and incentives information, we find a holidays section."

**On-screen actions:**
- Scroll down
- Show bonifications table first
- Continue scrolling to holidays section

---

### Scene 2.3: User's Holiday Calendar (30 seconds)

**[Screen: Holidays section]**

**Narrator:**
> "Here we see the holidays calendar specific to Colombia, which is the country configured in this user's profile. The table shows the country name, current year, and all holidays."

**On-screen actions:**
- Highlight title "Colombia - Public Holidays 2026"
- Scroll through holidays table
- Show some holidays: January 01 - New Year's Day, July 20 - Independence Day

**Narrator:**
> "Each holiday shows the date in a readable format and the holiday name in English. This information is automatically updated based on the user's country."

**On-screen actions:**
- Highlight date format "Month DD"
- Highlight holiday names

---

### Scene 2.4: Different Scenarios (25 seconds)

**[Screen: Demo of special scenarios]**

**Narrator:**
> "If a user is not authenticated, they'll see a message inviting them to log in. If the user doesn't have their country configured in their profile, they'll see a message to complete their information."

**On-screen actions:**
- [Optional] Quick logout - show message "Login to see holidays"
- [Optional] Login with user without country - show message "Complete your profile"

**Narrator:**
> "And if the user's country doesn't have holidays loaded in the system yet, they'll see a message indicating that the information is not yet available."

---

## CLOSING (30 seconds)

**[Screen: Split screen showing both views]**

**Narrator:**
> "In summary, we've seen how SuperAdmins can manage the complete holidays calendar for multiple countries, and how users can easily check their country's holidays on the bonifications page."

**[Screen: Animated bullet points]**

**Text on screen:**
- ✅ Centralized holidays management by country
- ✅ Intuitive interface for CRUD operations
- ✅ Automatic display based on user's country
- ✅ Always up-to-date information

**Narrator:**
> "This feature helps keep all contractors informed about holidays in their region. Thank you for watching this tutorial."

**[Screen: Andes Workforce Logo + contact information]**

**Text on screen:**
> **Questions?**  
> Contact the support team  
> support@andesworkforce.com

**[Fade out]**

---

## 📝 PRODUCTION NOTES

### Before Recording:

1. **Prepare test data:**
   - Database with loaded holidays for Colombia, Mexico, Argentina
   - SuperAdmin user: admin@test.com
   - Contractor user: contractor@test.com (country: Colombia)
   - User without country: contractor2@test.com

2. **Clean browser:**
   - Clear cache
   - No visible extensions
   - Incognito mode recommended

3. **Configure recording:**
   - Recommended resolution: 1920x1080
   - FPS: 30 or 60
   - Full screen or specific window capture
   - Clear audio without background noise

### During Recording:

4. **Action speed:**
   - Smooth and slow mouse movements
   - 1-2 second pauses after each important action
   - Allow animations/transitions to complete

5. **Highlight elements:**
   - Use zoom or highlighting on key elements
   - Circles or arrows to guide attention (post-editing)

6. **Time management:**
   - Don't exceed 7 minutes total
   - If any section is too long, consider splitting the video

### After Recording:

7. **Editing:**
   - Add intro/outro with logo
   - Soft background music (optional)
   - Subtitles in Spanish and English
   - Annotations or explanatory text when needed
   - Smooth transitions between sections
   - Zoom effects on important parts

8. **Export:**
   - Format: MP4
   - Codec: H.264
   - Quality: High (1080p minimum)
   - Include timestamps in video description

---

## 🎯 KEY POINTS TO HIGHLIGHT

### For SuperAdmin:
- ✅ Complete CRUD of holidays
- ✅ Organization by countries
- ✅ Efficient filters and search
- ✅ Intuitive and friendly interface

### For Users:
- ✅ Automatic display based on their country
- ✅ Always up-to-date information
- ✅ No additional configuration required
- ✅ Integrated in bonifications page

### General Benefits:
- ✅ Centralized information
- ✅ Reduces support team inquiries
- ✅ Improves communication with contractors
- ✅ Scalable to multiple countries

---

## 📊 PRE-RECORDING CHECKLIST

- [ ] Database with test data loaded
- [ ] Test users created and verified
- [ ] Backend running without errors
- [ ] Frontend running in production mode
- [ ] Script printed or on second screen
- [ ] Recording software configured
- [ ] Microphone tested
- [ ] Browser clean and configured
- [ ] System notifications disabled
- [ ] Script reviewed and rehearsed

---

## 🎥 SUGGESTED VARIATIONS

### Short Version (3 minutes):
- Reduce CRUD examples (only create and view)
- Omit error scenarios
- Focus on happy path

### Executive Version (1 minute):
- Only functionality highlights
- No detailed demos
- Overview of benefits

### Training Version (10-15 minutes):
- Include troubleshooting
- Explain technical structure
- Show more edge cases
- Include common Q&A

---

**Good luck with the recording!** 🎬
