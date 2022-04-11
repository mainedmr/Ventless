server <- function(input, output) { 
    
    # call login module supplying data frame, 
    # user and password cols and reactive trigger
    credentials <- shinyauthr::loginServer(
        id = "login",
        data = user_base,
        user_col = user,
        pwd_col = password,
        log_out = reactive(logout_init())
    )
    
    # call the logout module with reactive trigger to hide/show
    logout_init <- shinyauthr::logoutServer(
        id = "logout",
        active = reactive(credentials()$user_auth)
    )
    
    # Pulls out the user information returned from login module
    user_data <- reactive({credentials()$info}
    )

    
    # Show information on how to get a login
    form_url <- a(href = "https://forms.office.com/Pages/ResponsePage.aspx?id=q6g_QX0gYkubzeoajy-GTlzk_7jkUvJKp7wd1c3EbvVUMjY5QUozMVpYNzVBN0JYR1ZFTE5UUVIwQyQlQCN0PWcu","here")
    output$login_text <- renderUI({
        # Only show if user is NOT logged in
        req(credentials()$user_auth == F)
        # Build HTML with link to form etc
        tagList(
            #h3("HINT: Username = DMR, Password = pass1", align = "center"),
            HTML(paste('<h3 align="center">Please fill out the form', form_url, 
                       'to obtain a login for access to raw data on the Downloads tab.</h3>'))
        )
    })
    
    output$wsmap <- renderLeaflet({
        leaflet() %>% 
            addTiles(group = "OSM (default)") %>% 
            addCircleMarkers(
                data = Temp, 
                ~unique(meanLon), 
                ~unique(meanLat), 
                layerId = ~unique(ID), 
                popup = ~unique(ID))
    })
    
    # generate data in reactive
    ggplot_data <- reactive({
        site <- input$wsmap_marker_click$id
        Temp[Temp$ID %in% site,]
    })
    
    output$plot1 <- renderPlot({
        ggplot(data = ggplot_data(), aes(Date,meanTemp)) +
            labs(title = "Daily Average Temperature",
                 y = "Degrees Farenheit",
                 x = "Date") +
            theme(
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank(),                
                plot.background = element_rect(fill = "light gray"),
                panel.background = element_rect(fill = ' lightgray'),
                text = element_text(size=20),
                axis.text.x = element_text(angle=90,size=12),
                axis.text.y = element_text(angle=90,size=20)) +
            annotation_custom(g, xmin=-Inf, xmax=Inf, ymin=-Inf, ymax=Inf) +
            geom_point(shape=21,size=5,color="black",fill="orange")
    })
    
    output$download_page <- renderUI({
        # Require user to be logged in
        req(credentials()$user_auth == T)
        # Add ui elements for downloads
        tagList(
            # Create a tabbed nav list
            navlistPanel(widths = c(8, 2),
                         tabPanel(h4("Bio Data"),
                                  # Button on top to download
                                  downloadButton("dl_Bio", "Download Bio Data (csv)")),
                         tabPanel(h4("Catch Data"),
                                  # Button on top to download
                                  downloadButton("dl_Catch", "Download Catch Data (csv)")),
                         tabPanel(h4("Trap Data"),
                                  # Button on top to download
                                  downloadButton("dl_Trap", "Download Trap Data (csv)")),
                         tabPanel(h4("Trip Data"),
                                  # Button on top to download
                                  downloadButton("dl_Trip", "Download Trip Data (csv)")),
                         tabPanel(h4("Species Codes"),
                                  # Button on top to download
                                  downloadButton("dl_Species", "Download Species Data (csv)")),
                         tabPanel(h4("Port Codes"),
                                  # Button on top to download
                                  downloadButton("dl_Port", "Download Port Data (csv)")),
                         tabPanel(h4("Database Key"),
                                  # Button on top to download
                                  downloadButton("dl_Key", "Download Data Key (csv)"))
            )
        )
    })
    
    output$dl_Bio <- downloadHandler(
        filename = function() {
            paste("data-",Sys.Date(), ".csv", sep="")
        },
        content = function(file) {
            write.csv(Bio,file)
        })
    
    output$dl_Catch <- downloadHandler(
        filename = function() {
            paste("data-",Sys.Date(), ".csv", sep="")
        },
        content = function(file) {
            write.csv(Catch,file)
        })
    
    output$dl_Trap <- downloadHandler(
        filename = function() {
            paste("data-",Sys.Date(), ".csv", sep="")
        },
        content = function(file) {
            write.csv(Trap,file)
        })
    
    output$dl_Trip <- downloadHandler(
        filename = function() {
            paste("data-",Sys.Date(), ".csv", sep="")
        },
        content = function(file) {
            write.csv(Trip,file)
        }) 
    
    output$dl_Species <- downloadHandler(
        filename = function() {
            paste("data-",Sys.Date(), ".csv", sep="")
        },
        content = function(file) {
            write.csv(Species,file)
        })
    
    output$dl_Port <- downloadHandler(
        filename = function() {
            paste("data-",Sys.Date(), ".csv", sep="")
        },
        content = function(file) {
            write.csv(Port,file)
        })
    output$dl_Key <- downloadHandler(
        filename = function() {
            paste("data-",Sys.Date(), ".csv", sep="")
        },
        content = function(file) {
            write.csv(Key,file)
        })
    
    observe({
              req(user_data()$permissions)
              if(user_data()$permissions == 'standard') {
                showTab(inputId = "tab_panel", target = "raw")
              } else {
               hideTab(inputId = "tab_panel", target = "raw")
              }
            })
                         
}

shinyApp(ui, server)
