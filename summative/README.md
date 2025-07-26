![Python](https://img.shields.io/badge/Python-Model%20%26%20API-green.svg) ![FastAPI](https://img.shields.io/badge/FastAPI-Endpoint-blue.svg) ![Render](https://img.shields.io/badge/Render-Deployment-purple.svg) ![Flutter](https://img.shields.io/badge/Flutter%20App-API%20Client-orange.svg) ![Contributors](https://img.shields.io/badge/contributors-1-yellow.svg)

# Educational AI Project: Student Final Math Grade Prediction

## Mission

My mission is to use artificial intelligence to enhance and streamline educational processes in Africa, with the goal of developing a world-class education system and improving learning outcomes for all students. While this project is only a starting point, it serves as an initial step toward understanding how AI can be applied to improve educational outcomes.

## Data Description

The objective of this project is to predict student final math grades (G3) using various academic, demographic, and social factors. This is based on the **student-mat.csv** dataset, which contains several columns capturing different attributes of students such as family background, school performance, and social behaviors. The ultimate goal is to identify students at risk of underperforming, providing educators and parents with the ability to offer timely support and interventions. By predicting student outcomes in mathematics, this project aims to improve educational practices and the way students are supported throughout their learning journey.

### Data Source
- **Dataset**: [student-mat.csv](https://www.kaggle.com/code/janiobachmann/predicting-grades-for-the-school-year/)
- **Source**: Kaggle

### Demo Video
- **Youtube**: [student-grade-prediction-video](https://youtu.be/B4OS_Tp-6kg)

### Citation
This dataset is provided by **Janio Martinez Bachmann**, a Kaggle Grandmaster and Business Intelligence Analyst at Roche. The dataset can be accessed on Kaggle and used for educational and predictive analysis purposes.

- **Janio Martinez Bachmann**
  - Kaggle Grandmaster
  - Barcelona, Catalonia, Spain
  - BI Analyst at Roche

### Installation Before Running Sections of the Project

- **Clone the repository**.
    ```bash
    git clone https://github.com/eobolo/Machine-Learning-Regression-Summative.git
    ```
## API Overview
This FastAPI-based web service predicts the final math grade (G3) of students using various academic, demographic, and social factors. The model takes into account data such as the student's family background, study habits, and social life, providing a prediction that helps educators and parents identify students who might need additional support.

### Endpoints

### **Endpoint**: `/predict`
- **Method**: `POST`
- **Description**: This endpoint predicts a student's final grade based on the provided input data.
- **Input Format**: JSON request body containing various attributes related to the student.
- **Response Format**: JSON response with the predicted final grade.

#### Example Request:
```json
{
  "school": "GP",
  "sex": "F",
  "address": "U",
  "famsize": "GT3",
  "Pstatus": "T",
  "Mjob": "teacher",
  "Fjob": "health",
  "reason": "course",
  "guardian": "mother",
  "schoolsup": "yes",
  "famsup": "yes",
  "paid": "yes",
  "activities": "yes",
  "nursery": "yes",
  "higher": "yes",
  "internet": "yes",
  "romantic": "no",
  "age": 17,
  "Medu": 3,
  "Fedu": 3,
  "traveltime": 2,
  "studytime": 2,
  "failures": 0,
  "famrel": 5,
  "freetime": 4,
  "goout": 3,
  "Dalc": 1,
  "Walc": 1,
  "health": 3,
  "absences": 10
}
```
### Example Response:
```json
{
  "final_grade_prediction": 16.4
}
```

### **Endpoint**: `/columns`
- **Method**: `GET`
- **Description**: This endpoint returns metadata about the columns used in the prediction model.
- **Response Format**: JSON response with column names used in training the model.

#### Example Response:
```json
[
    {
        "name": "school",
        "type": "str",
        "allowed_values": ["GP", "MS"],
        "description": "The school of the student. 'GP' for Gabriel Pereira and 'MS' for Mousinho da Silveira."
    },
    {
        "name": "higher",
        "type": "str",
        "allowed_values": ["yes", "no"],
        "description": "Wants to pursue higher education: 'yes' or 'no'."
    },
    {
        "name": "internet",
        "type": "str",
        "allowed_values": ["yes", "no"],
        "description": "Internet access at home: 'yes' or 'no'."
    },
    .
    .
    .
    {
        "name": "Walc",
        "type": "int",
        "allowed_values": [1, 2, 3, 4, 5],
        "description": "Weekend alcohol consumption (1 = very low, 5 = very high)."
    },
    {
        "name": "health",
        "type": "int",
        "allowed_values": [1, 2, 3, 4, 5],
        "description": "Current health status (1 = very bad, 5 = very good)."
    }
]
```
# How to Use the API

## Deploy the FastAPI Application
The application is deployed on Render and is accessible at the following URL:  
[https://student-math-final-grade-submission.onrender.com/docs](https://student-math-final-grade-submission.onrender.com/docs)  
This link opens the Swagger UI, where you can test the API endpoints.

## Interact with the API
- Visit the Swagger UI to view and test the available endpoints.
- Use the `/predict` endpoint to submit student data and receive grade predictions.
- Use the `/columns` endpoint to get information on the dataset used in the model.

## Dataset and Model Details

### Dataset:
The dataset used for training the model is `student-mat.csv`, which contains data related to students' academic performance and their demographic, social, and academic factors. The features in the dataset include both categorical and numerical attributes such as family background, study habits, and student behavior.

### Objective:
The goal of this project is to predict student final math grades (G3) based on various academic, demographic, and social factors. This prediction can help identify students at risk of underperforming, enabling early intervention and support.

### Model:
The model used to predict the final grade is trained on the dataset mentioned above and is saved as `best_model.pkl`. The model is then loaded and used to make predictions when a POST request is made to the `/predict` endpoint.

### Metadata:
The metadata file (`metadata.json`) contains additional information about the columns used in the dataset and model, which can be retrieved using the `/columns` endpoint.

## Installation & Local Testing

### Prerequisites:
- Python 3.11 or later
- FastAPI
- Uvicorn
- Pandas
- Joblib
- Pydantic
- Scikit-learn

## Navigate to the API directory
```bash
cd summative/API
```

### Install Dependencies:
```bash
pip install -r requirements.txt
```
### Run Locally:
To run the application locally for testing purposes, use the following command:

```bash
uvicorn API.prediction:app --reload
```


## Flutter App Documentation

### Overview
The Flutter application allows users to input student data through a form with dropdown menus for categorical fields and text inputs for numerical fields. Upon submission, the app sends a request to the `/predict` endpoint of the API to fetch the predicted final grade. The result is displayed on a beautifully designed card with an elegant screen transition animation.

### Features
1. **Input Form**:
   - Dropdown menus for categorical fields (e.g., `school`, `sex`, `address`).
   - Text input fields for numerical fields (e.g., `age`, `absences`).

2. **Prediction Screen**:
   - Displays the predicted final grade on a stylish card.
   - Prediction value is formatted to 3 decimal places for clarity.
   - Includes a "Back" button to return to the input form.

3. **Smooth Screen Transitions**:
   - Custom animations for navigating between screens using the `PageRouteBuilder` with fade-in and scale effects.

4. **API Integration**:
   - Sends POST requests to the `/predict` endpoint with the user-provided data.
   - Handles errors gracefully, displaying error messages in case of failed requests.

### Installation & Running the App

1. Navigate to the flutter app directory.
    ```bash
    cd summative/FlutterApp/student_math_final_grade_prediction_app
    ```

2. Install dependencies by running:
    ```bash
    flutter pub get
    ```
    ```bash
    flutter run
    ```
