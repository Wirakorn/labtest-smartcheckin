# Product Requirement Document (PRD)

## Smart Class Check-in & Learning Reflection App

## 1. Problem Statement

In traditional classrooms, instructors often cannot confirm whether
students are physically present in class or actively participating in
the learning process. Manual attendance systems are inefficient and do
not capture student engagement or learning reflection.

This project aims to build a simple mobile application that allows
students to check in to class using location verification and QR code
scanning. The system will also collect short learning reflections from
students before and after class to encourage engagement and provide
feedback to instructors.

The application will serve as a prototype demonstrating how mobile
technologies can support classroom participation tracking.

------------------------------------------------------------------------

# 2. Target Users

Primary users:

**University students**

Students will use the application to: - Check in before class - Confirm
attendance using QR code and GPS location - Reflect on their learning
before and after class

Secondary users (future extension):

**Instructors**

Instructors could use the collected data to review attendance and
student feedback.

------------------------------------------------------------------------

# 3. Feature List

## 1. Class Check-in

Students can check in before class by: - Pressing the **Check-in
button** - Scanning the **class QR code** - Recording **GPS location** -
Recording **timestamp**

Students must also fill out a short form including: - Topic from the
previous class - Expected topic for today's class - Mood before class
(1--5 scale)

------------------------------------------------------------------------

## 2. Class Completion

At the end of class, students must: - Press **Finish Class** - Scan the
**QR code again** - Record **GPS location**

Students must also enter: - What they learned today - Feedback about the
class or instructor

------------------------------------------------------------------------

## 3. Data Storage

The application stores attendance and reflection data locally using
**SQLite**.

Stored information includes: - Check-in time - Check-out time - GPS
coordinates - Reflection responses

------------------------------------------------------------------------

# 4. User Flow

## Step 1 -- Open Application

Student opens the mobile app and arrives at the **Home Screen**.

## Step 2 -- Check-in

Student presses **Check-in**.

System will: 1. Request GPS location 2. Scan QR Code 3. Record timestamp

Student fills in the check-in form: - Previous class topic - Expected
topic today - Mood rating

Data is saved.

------------------------------------------------------------------------

## Step 3 -- Finish Class

At the end of class: 1. Student presses **Finish Class** 2. Scan QR Code
3. GPS location is recorded again

Student fills in: - What they learned today - Class feedback

Data is saved.

------------------------------------------------------------------------

# 5. Data Fields

  Field           Description
  --------------- --------------------------------
  studentId       Student identifier
  checkInTime     Time when student checks in
  checkOutTime    Time when class ends
  gpsLatitude     Latitude location
  gpsLongitude    Longitude location
  previousTopic   Topic from previous class
  expectedTopic   Topic expected today
  mood            Mood rating (1--5)
  learnedToday    Student reflection after class
  feedback        Feedback about class

------------------------------------------------------------------------

# 6. Tech Stack

## Mobile Application

-   Flutter

## Backend / Cloud

-   Firebase

## Data Storage (MVP)

-   SQLite (local storage)

## Additional Libraries

-   QR Code Scanner package
-   Geolocator package for GPS

------------------------------------------------------------------------

# 7. Success Criteria

The prototype will be considered successful if:

-   Students can check in successfully
-   GPS location can be retrieved
-   QR code can be scanned
-   Forms can collect student reflections
-   Data can be saved locally
-   At least one component is deployed using Firebase Hosting
