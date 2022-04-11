library(shiny)
library(shinythemes)
library(leaflet)
library(tidyverse)
library(ggplot2)
library(grid)
library(DT)
library(shinyjs)
library(sodium)
library(shinyauthr)
library(RSQLite)
library(DBI)

# data
load("Ventless.Rda")
Temp <- read.csv("X:/Bio Monitor/Ventless Trap Survey/Ventless Survey Portal/medmr_ventless/Temp.csv")
Trap <- read.csv("X:/Bio Monitor/Ventless Trap Survey/Ventless Survey Portal/medmr_ventless/Trap.csv")
Trip <- read.csv("X:/Bio Monitor/Ventless Trap Survey/Ventless Survey Portal/medmr_ventless/Trip.csv")
Species <- read.csv("X:/Bio Monitor/Ventless Trap Survey/Ventless Survey Portal/medmr_ventless/Species.csv")
Port <- read.csv("X:/Bio Monitor/Ventless Trap Survey/Ventless Survey Portal/medmr_ventless/Port.csv")
Catch <- read.csv("X:/Bio Monitor/Ventless Trap Survey/Ventless Survey Portal/medmr_ventless/Catch.csv")
Bio <- read.csv("X:/Bio Monitor/Ventless Trap Survey/Ventless Survey Portal/medmr_ventless/Bio.csv")

# tables and images
Fig1 <- base64enc::dataURI(file="Fig1.png", mime="image/png")
Picture1 <- base64enc::dataURI(file="Picture1.jpg", mime="image/png")
Picture2 <- base64enc::dataURI(file="Picture2.jpg", mime="image/png")
Table1 <- base64enc::dataURI(file="Table1.png", mime="image/png")
Logo <- base64enc::dataURI(file="Logo.png", mime="image/png")
g <- rasterGrob(blues9, width=unit(1,"npc"), height = unit(1,"npc"), 
                interpolate = TRUE)

# dataframe that holds usernames, passwords and other user data
user_base <- tibble::tibble(
    user = "DMR1",
    password = "lobster21",
    permission = "standard",
    name = "User One"
)

#begin ui
ui <- fluidPage(theme = shinytheme("united"),
    # Add logout button UI 
    div(class = "pull-right", shinyauthr::logoutUI(id = "logout")),
    # add login panel UI function
    shinyauthr::loginUI(id = "login"),
    uiOutput("login_text"),
    br(),

    mainPanel(
        tabsetPanel(type = "tabs",
                    tabPanel("About the Program",
                                         img(src=Logo, width="20%", style="display: block; margin-left: auto; margin-right: auto;"),
                                         h1("Welcome to the  Maine Ventless Trap Survey Home Page", style="display: block; margin-left: auto; margin-right: auto;"),
                                         h4("The Maine Ventless Trap Survey (VTS) is a collaborative program between industry and government to further our understanding of juvenile lobster dispersal within Maine state waters."),
                                         h3("Program Origins"),
                                         p("In 2006, Maine's Department of Marine Resources commenced a cooperative random stratified ventless trap survey, designed to target the juvenile lobster population. This program aims to generate estimates of the spatial distribution of lobster length frequency, relative abundance and recruitment while attempting to eliminate the biases identified in conventional fishery dependent surveys. In the past, fishery-dependent trap sampling data have not been included in generating relative abundance indices for the American Lobster due to associated bias with the data collection method. Lobstermen are very efficient at catching lobsters and will only fish where lobsters tend to congregate. Gear deployment often follows annual lobster migrations, and thus we were not provided with an accurate picture of the resource relative to the entire area. A fishery-independent survey, wherein scientists and contracted fishermen cooperatively collect data, provides greater control over the sampling design, data quality and quantity necessary to maintain a stratified sampling approach that provides unbiased data."),
                                         h3("Project Objectives"),
                                         tags$ul(
                                             tags$li("Accurately characterize relative abundance and size distribution of American lobster from Maine through New York."),
                                             tags$li("Develop a coast-wide fishery independent monitoring program for American lobster using ventless Traps."),
                                             tags$li("Improve collaborative relationship between the commercial lobster industry, fisheries scientists and managers in the interest of strengthening our combined understanding of the lobster resource.")),
                                         h3("Navigating this website"),
                                         h4("Survey Design"),
                                         p("Contains the program description and experimental design, as well as timeline."),
                                         h4("Abundance Estimates"),
                                         p("Contains information in regards to Catch per unit effort (CPUE) by way of stratified-means."),
                                         h4("Temperature Data"),
                                         p("Contains information gathered during the survey by way of small Portable data loggers designed to measure water temperature. These devices are typically stored within the lobster Traps themselves."),
                                         h4("How to Get Involved"),
                                         p("Contains information relevant to fishermen who would like to participate in future surveys. Contact information can be found here."),
                                         h4("Downloads"),
                                         p("Contains access to raw data files following login.")
                                 ),
                    tabPanel("Design",
                             h1("Survey Design"),
                             h2("Description"),
                             p("Sampling in Maine is divided into three depth strata [1 to 20 m, 21 to 40 m and 41 to 60 m] and three National Marine Fisheries Service statistical areas [511, 512, and 513; Figure 1]. Each area is sampled using randomly selected sites of three baited ventless Traps [40 x 21 x 16] for a total of 276 sites across the state. Fishermen are selected through competitive bid. Cooperating lobsterman haul through their ventless traps twice-monthly in June, July and August, each time following a three-night soak. Sea samplers record Biological data in an identical method to that used in the Lobster Sea Sampling program. Sampling is performed by nine different contracted vessels for a total of 54 hauling trips throughout the season."),
                             img(src=Fig1, width = "60%"),
                             h4("Figure 1. Map of Lobster Zones [black] and federal statistical areas [white]"),
                             h3("Survey Routes (North to South)"),
                             tags$ul(
                                 tags$li("Canadian Border to Addison"),
                                 tags$li("Addison to Mount Desert Island"),
                                 tags$li("Mount Desert Island to Isle au Haut"),
                                 tags$li("North Penobscot Bay"),
                                 tags$li("South Penobscot Bay"),
                                 tags$li("Muscongus Bay to Metinicus"),
                                 tags$li("Muscongus to Harpswell"),
                                 tags$li("Casco Bay"),
                                 tags$li("Cape Elizabeth to NH Border")),
                             h3("Survey Timeline"),
                             p("The Ventless Trap Survey has evolved over time to improve its capacity. The following table is a timeline displaying operation changes in its design. The survey has been sampling in its current state since 2015."),
                             img(src=Table1),
                             h4("L - Vented lobster pot; V - Ventless lobster pot")
                    ),
                    tabPanel("Abundance",
                             h1("Ventless Trap Survey Estimates"),
                             h2("2021 Results"),
                             img(src=Picture2, width = "60%"),
                             h4("Figure 2. Mean sublegal Catch per Trap stratified by depth by statistical area for 2006-2021 from the Ventless Trap Survey"),
                             p("This is the 16th year of the Ventless Trap Survey. Sublegal Catch in 2021 showed significant decline in central Maine; however, levels in western and eastern Maine observed similar Catch to that of 2020. In recent years, Catch-per-Trap of sublegals has been on a declining trend in midcoast and eastern Maine, whereas estimated Catch per Trap in western Maine appears more stable, with only small fluctuations between years.")
                             ),
                    tabPanel("Temps",
                             h1("Temperature Data"),
                             fluidRow(
                                 box(
                                     title = "Logger Deployments",
                                     solidHeader = TRUE,
                                     background = "navy",
                                     width = 12,
                                     height = 470,
                                     leafletOutput("wsmap")
                                 ),
                                 box(solidHeader = TRUE,
                                     background = "navy",
                                     width = 12,
                                     height = 440,
                                     plotOutput("plot1"))
                                 )
                             ),
                    tabPanel("Participation",
                             h1("How to Get Involved"),
                             h2("Industry Participation"),
                             p("The Department of Marine Resources, in cooperation with the Gulf of Maine Lobster Foundation, seeks three industry participants for the Regional Ventless Trap Program through a competitive bid process. This is an opPortunity to participate in a cooperative research project between industry and scientists from Maine through New York.  Three of nine legs are open for bid each year, and contracts last for 3 years.  Each leg will have 80-100 small mesh traps rigged as Triples randomly located at three depths. Sampling will take place during June, July and August of a given year.  Each trap will be baited and hauled twice each month on three night soaks making a total 3 day commitment each month.  The lobster Catch will be measured by a sea sampler and immediately returned to the ocean.  All traps, line and buoys will be supplied to participating fishermen.  Interested parties will need to complete the application to identify vessel specifications, daily rate and preferred sampling leg."),
                             h3("Requirements"),
                             h4("1. A vessel ready for work at agreed-upon dates, times and places including:"),
                             tags$ul(
                                 tags$li("Coast Guard Safety Inspection at the time of the survey"),
                                 tags$li("Protection and Indemnity Insurance (please provide the DMR with a current Certificate of Insurance"),
                                 tags$li("Capacity to transPort and haul approximately 80-100 lobster traps"),
                                 tags$li("Working electronics to provide depth, location and to facilitate safe navigation"),
                                 tags$li("Safety equipment for the captain, crew and up to two scientific staff (survival suits for scientific staff will be provided)"),
                                 tags$li("Adequate fuel and bait"),
                                 tags$li("Adequate crew to perform work")
                             ),
                             h4("2. A captain who is able to:"),
                             tags$ul(
                                 tags$li("Provide knowledge of the Maine lobster fishery practices"),
                                 tags$li("Complete the specified trips on schedule, except if delayed by weather (Vessel bears risk and expense of weather delays)"),
                                 tags$li("Record location, depth, and counts of lobsters and crab in the logbook"),
                                 tags$li("Participate in project meetings"),
                                 tags$li("Rig specified number of Traps, buoys and line for each leg under contract")
                             ),
                             h3("Application  Review, Contract and Payment"),
                             h4("Applications will be reviewed and ranked given the following guidelines:"),
                             tags$ul(
                                 tags$li("Experience of captain in lobster fishery and Marine Patrol recommendation (30 points)"),
                                 tags$li("Vessel specifications (size, cruising speed, electronics etc) (30 points)"),
                                 tags$li("Experience and commitment of captain to fishery research (10 points)"),
                                 tags$li("Vessel charter day rate (30 points)")
                             ),
                             h4("Contracts will be signed with the Gulf of Maine Lobster Foundation. Payments will be processed within 7 business days of invoice."),
                             h3("To learn more, please contact:"),
                             h4("Kathleen Reardon"),
                             tags$div("Senior Lobster Biologist", tags$br(),
                                      "Maine Department of Marine Resources", tags$br(),
                                      "P.O. Box 8", tags$br(),
                                      "West Boothbay Harbor, ME 04575", tags$br(),
                                      "Email: Kathleen.Reardon@Maine.gov", tags$br(),
                                      "Cell: (207) 350-7440"),
                             h2("Thank you!"),
                             img(src=Picture1)
                    ),
                    tabPanel("Downloads", 
                             value = "raw",
                             uiOutput("download_page"),
                             h4("To report any issues, please contact:"),
                             tags$div("Matt Davis", tags$br(),
                                      "Maine Department of Marine Resources", tags$br(),
                                      "P.O. Box 8,", tags$br(),
                                      "West Boothbay Harbor, ME 04575", tags$br(),
                                      "Email: Matthew.M.Davis@Maine.gov"))
        )
    )
)
