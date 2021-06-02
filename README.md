# fetchAnalyticsTest

First:Review Existing Unstructured Data and Diagram a New Structured Relational Data Model
I left out some of the fields(like the metabrite). would need more info before adding it to the model
I uploaded the pdf of the model (the pdf output pnly has 2 pages that are filled in)
The file "mysql_workbench_model diagram" was created using mysql workbench



Second: Write a query that directly answers a predetermined question from a business stakeholder
the sql query is uploaded



Third: Evaluate Data Quality Issues in the Data Provided
The query needs to be run in Microsoft sql server 2019.
I replaced the linebreaks with a comma and enclosed all the contents on the receipts.json file within "[" and "]" I flattened the receipts.json using the functinos in sql server.
looked for missing data. couldn't identify any missing data that could be an error. 
looked for dates to make sure that lined up. 
  found that for 13 receipts, the dateScanned was before the datePurchased.



Fourth:Communicate with Stakeholders

What questions do you have about the data?
  I not sure how the MetaBrite data is connected to the receipts on line items on a receipt. I read online that it is a company that analyses receipts, ate the metabrite data used to read the receipts and connect it to a item?
  
How did you discover the data quality issues?
  I looked to see if there were any dates out of order. 
  Found that for the about 13 of the 1119 receipts, the datescanned was before the date purchased which may need further reveiw. 
    * The number of errored receipts small and the error is likely immaterial for most analysis. But may need to look at cause
    
What do you need to know to resolve the data quality issues?
  Would need to work with someone to review the receipts to visually identify the correct date purchased from the receipt. May also need to the person incharge of the source of the data to see if they can correct for it in the app/program.

What other information would you need to help you optimize the data assets you're trying to create?
  More info on how the below groups of the fields are connected to each other.
    * MetaBrite fields
    * partnerItemId - i am not sure what this represents. It seems random. may need to ask the person incharge of the source of the data
    * top brand field - do the timeperiods when the brand was a top brand need to be tracked for analysis?

What performance and scaling concerns do you anticipate in production and how do you plan to address them?
  I am not sure.

