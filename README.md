# My Text Classifier

## About Project
My Text Classifier is an application to create text classification models from JSON files. 
Based on [Create ML](https://developer.apple.com/machine-learning/create-ml/) and made for macOS. 
In the application you can export the created model as .mlmodel, as well as create your own JSON or import it. 
In addition, you have access to your model's accuracy data and can perform prediction checks in the interface itself. 
You will also have access to the entire application log.

## The Application

This is the main screen where you can perform the following functions:
![contentView](https://github.com/Robsonmxms/TextClassifier/blob/main/ReadMeAssets/ContentView.png)


- Import the json and train the model

  ![getJson](https://github.com/Robsonmxms/TextClassifier/blob/main/ReadMeAssets/getJson.gif)

- Create your own json file

  ![createJson](https://github.com/Robsonmxms/TextClassifier/blob/main/ReadMeAssets/createjson.gif)
  
  - To create a json file you need to follow the following structure:

    ```json
    [
       {
            "text": "There is a text for validation",
            "validation": "validation label"
        },
         {
              "text": "There is a text for validation",
              "validation": "validation label"
          }
    ]
    ```
- Check your model prediction
  
  ![checkPrediction](https://github.com/Robsonmxms/TextClassifier/blob/main/ReadMeAssets/verifyModel.gif)
  This model used was a classification of skills created for RPG and was in Portuguese, 
  the written phrase means: "jump on top of 5 platforms". The return was "negativo" which means negative   
  
- Save your model
  
  ![saveModel](https://github.com/Robsonmxms/TextClassifier/blob/main/ReadMeAssets/saveModel.gif)
  
## For the Future

- Allow importing and manipulation of csv files
- Transform business logic into a package that can be used in other projects
- Use Computer Vision to extract text from images and classify them
