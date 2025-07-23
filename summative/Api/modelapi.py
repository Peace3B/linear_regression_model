from fastapi import FastAPI
from pydantic import BaseModel, Field
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
import joblib
import math

# Initialize the FastAPI app
app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
# Load the model
model = joblib.load('randomforest_model.pkl')




# Define a root endpoint
@app.get("/")
async def root():
    return {"message": "Welcome to the Model API. Use /predict to make predictions or /sample-data to view sample input data."}

# Define a sample data endpoint
@app.get("/sample-data")
async def sample_data():
    sample = {
        "age": 30,
        "total_working_years": 8,
        "years_in_current_role": 4,
        "years_since_last_promotion": 2,
        "years_with_curr_manager": 3,
        "job_level": 2,
        "monthly_income": 5000
    }
    return {"sample_input_data": sample}

# Define a data schema for the input using Pydantic
class ModelInput(BaseModel):
    age: float = Field(..., ge=18, le=61)  
    total_working_years: float = Field(..., ge=0, le=40)
    years_in_current_role: float = Field(..., ge=0, le=18)
    years_since_last_promotion: float = Field(..., ge=0, le=15)
    years_with_curr_manager: float = Field(..., ge=0, le=17)
    job_level: float = Field(..., ge=1, le=5)
    monthly_income: float = Field(..., ge=0, le=20000)

# Define the prediction endpoint
@app.post("/predict")
async def predict(input_data: ModelInput):
    # Prepare data for the model
    features = [[
        input_data.age,
        input_data.total_working_years,
        input_data.years_in_current_role,
        input_data.years_since_last_promotion,
        input_data.years_with_curr_manager,
        input_data.job_level,
        input_data.monthly_income,
    ]]

    # Make the prediction
    prediction = model.predict(features)
    
    # Return the prediction as a response
    return {"They will likely spend ": math.ceil(prediction[0])}

# Add this to run the server locally using Uvicorn
if __name__ == "__main__":
    uvicorn.run("modelapi:app", host="127.0.0.1", port=8000, reload=True)