Finding the best hospital in a state
Write a function called best that take two arguments:  the 2-character abbreviated name of a state and an outcome name.  The function reads the outcome-of-care-measures.csv file and returns a character vector with  the  name  of  the  hospital  that  has  the  best  (i.e.   lowest)  30-day  mortality  for  the  specified  outcomein that state.  The hospital name is the name provided in the Hospital.Name variable.  The outcomes canbe one of “heart attack”, “heart failure”, or “pneumonia”.  Hospitals that do not have data on a particular outcome should be excluded from the set of hospitals when deciding the rankings.Handling ties.  If there is a tie for the best hospital for a given outcome, then the hospital names should be sorted in alphabetical order and the first hospital in that set should be chosen (i.e.  if hospitals “b”, “c”,and “f” are tied for best, then hospital “b” should be returned).

The function should use the following template.
best <- function(state, outcome) {
  Read outcome data
  Check that state and outcome are valid
  Return hospital name in that state with lowest 30-day death
  rate}The function should check the validity of its arguments.  
 
If an invalid state value is passed to best,  the function should throw an error via the stop function with the exact message “invalid state”.  If an invalid outcome value is passed tobest, the function should throw an error via the stop function with the exact message “invalid outcome”.


Ranking hospitals by outcome in a state
Write a function called rankhospital that takes three arguments:  the 2-character abbreviated name of astate (state), an outcome (outcome), and the ranking of a hospital in that state for that outcome (num).The function reads the outcome-of-care-measures.csv file and returns a character vector with the name of the hospital that has the ranking specified by thenumargument.  For example, the call rankhospital("MD", "heart failure", 5) would return a character vector containing the name of the hospital with the 5th lowest 30-day death ratefor heart failure.  The num argument can take values “best”, “worst”,  or an integer indicating the ranking(smaller numbers are better).  If the number given by num is larger than the number of hospitals in that state, then the function should return NA. Hospitals that do not have data on a particular outcome should be excluded from the set of hospitals when deciding the rankings.Handling ties.  It may occur that multiple hospitals have the same 30-day mortality rate for a given cause of death.  In those cases ties should be broken by using the hospital name.

The function should check the validity of its arguments.  If an invalid state value is passed to rankhospital,the function should throw an error via the stop function with the exact message “invalid state”.  If an invalid outcome value is passed to rankhospital, the function should throw an error via the stop function with the exact message “invalid outcome”.



Ranking hospitals in all states
Write a function called rankall that takes two arguments: an outcome name (outcome) and a hospital rank-ing (num).  The function reads the outcome-of-care-measures.csv file and returns a 2-column data frame containing the hospital in each state that has the ranking specified innum.  For example the function call rankall("heart attack", "best") would return a data frame containing the names of the hospitals that are the best in their respective states for 30-day heart attack death rates.  The function should return a value for every state (some may be NA). The first column in the data frame is namedhospital, which contains the hospital name, and the second column is namedstate, which contains the 2-character abbreviation forthe state name.  Hospitals that do not have data on a particular outcome should be excluded from the set of hospitals when deciding the rankings.Handling ties.  The rankall function should handle ties in the 30-day mortality rates in the same way that the rankhospital function handles ties. 

The function should use the following template.
rankall <- function(outcome, num = "best") {
  Read outcome data
  Check that state and outcome are valid
  For each state, find the hospital of the given rank
  Return a data frame with the hospital names and the (abbreviated) state name}
  
NOTE: For the purpose of this part of the assignment (and for efficiency), your function should NOT call therankhospital function from the previous section.The function should check the validity of its arguments.  If an invalid outcome value is passed to rankall,the function should throw an error via the stop function with the exact message “invalid outcome”.  The num variable can take values “best”, “worst”, or an integer indicating the ranking (smaller numbers are better). If the number given by num is larger than the number of hospitals in that state, then the function should return NA.
