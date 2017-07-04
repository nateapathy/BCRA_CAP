# BCRA_CAP
Visualization of Center for American Progress BCRA Medicaid Losses.

This is a project in R using the geofacet package to visualize data across states.

I use data from the Center for American Progress, published June 26, 2017, on projected Medicaid coverage losses under BCRA by insurance type.

I matched by state with 2013 Medicaid enrollment numbers from MACPAC to determine the percentage, by coverage type, that those losses would represent

Note: CAP used the 2013 MACPAC enrollment data in their projections, so I felt it appropriate to use the same numbers here.

Links to all content, including a google sheet with all of the data, can be found in the R script in the header.

Link to CAP blog post: https://www.americanprogress.org/issues/healthcare/news/2017/06/27/435112/coverage-losses-state-senate-health-care-repeal-bill/

Link to my writeup of the visualization steps (prose version of annotated R script): http://www.nateapathy.com/blog/capbcra

![Visualization of coverage losses](medicaid_coverage_losses.png)
