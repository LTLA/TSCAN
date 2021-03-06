######################################################
##                      TSCAN                       ##
##             Interactive User Interface           ##
##                     UI File                      ##
##           Author:Zhicheng Ji, Hongkai Ji         ##
##       Maintainer:Zhicheng Ji (zji4@jhu.edu)      ##
######################################################

shinyUI(      
      pageWithSidebar(
            
            headerPanel('TSCAN: Tools for Single-Cell ANalysis'),
            
            sidebarPanel(
                  
                  wellPanel(
                        helpText(a("Youtube short video demo",href="https://www.youtube.com/watch?v=zdcBAVe1GBE",target="_blank")),
                        radioButtons("MainMenu","Main Menu",
                                     list("Reading in dataset"="Input",
                                          "Preprocessing"="Preprocess",
                                          "Cell ordering"="Ordering",
                                          "Differential gene analysis (optional)"="Difftest",
                                          "Single gene visualization (optional)"="Visualization",
                                          "Miscellaneous (optional)"="Miscellaneous",
                                          "About"="About")
                        )
                  ),
                  
                  conditionalPanel(condition="input.MainMenu=='Input'",
                                   wellPanel(
                                         h5("Input Dataset"),
                                         fileInput('InputFile', 'Choose File'),
                                         p(actionButton("Inputreadin","Read in")),
                                         checkboxInput('Inputheader', 'Header', TRUE),
                                         radioButtons('Inputsep', 'Separator',
                                                      c('Tab'='\t',
                                                        'Space'=' ',
                                                        'Comma(csv)'=',',
                                                        'Semicolon'=';'
                                                      ),
                                                      '\t'),
                                         radioButtons('Inputquote', 'Quote',
                                                      c('None'='',
                                                        'Double Quote'='"',
                                                        'Single Quote'="'"),
                                                      '')
                                   ),
                                   wellPanel(
                                   checkboxInput("Preprocesslogtf","Take log of current data",value = T),
                                   conditionalPanel(condition="input.Preprocesslogtf==1",
                                                    wellPanel(radioButtons("Preprocesslogbase","Choose log base",choices = c("2","10","e")),
                                                              textInput("Preprocesslogpseudocount","Enter pseudo count added when taking log",value = 1)
                                                    )                                                          
                                   ))                                                                      
                  ),
                  
                  #                   conditionalPanel(condition="input.MainMenu=='Preprocess'",
                  #                                    wellPanel(                                         
                  #                                          wellPanel(
                  #                                                h5("Select genes"),
                  #                                                helpText("These genes will be used for constructing pseudo time cell ordering:"),
                  #                                                textInput("Preprocessexpvalcutoff","Expression value larger than",1),
                  #                                                sliderInput("Preprocessexppercent","In at least",min=0,max=1,value=0.3,step=0.01,format="##%"),
                  #                                                helpText("percentage of all cells"),
                  #                                                textInput("Preprocesscvcutoff","And coefficient of variance larger than",1)),
                  #                                          checkboxInput("Preprocesslogtf","Take log of current data",value = T),
                  #                                          conditionalPanel(condition="input.Preprocesslogtf==1",
                  #                                                           wellPanel(radioButtons("Preprocesslogbase","Choose log base",choices = c("2","10","e")),
                  #                                                                     textInput("Preprocesslogpseudocount","Enter pseudo count added when taking log",value = 1)
                  #                                                           )                                                          
                  #                                          )
                  #                                    )
                  #                   ),
                  
                  conditionalPanel(condition="input.MainMenu=='Preprocess'",                                   
                                   h5("Hierarchical clustering"),
                                   helpText("Perform hierarchical clustering to deal with potential drop out events in single-cell RNA-seq data. Genes with zero expression in all cells are excluded."),
                                   checkboxInput("Preprocessclustertf","Do not perform clustering",value=T),
                                   conditionalPanel(condition="input.Preprocessclustertf==0",
                                                    helpText("Choose number of clusters:"),
                                                    textInput("Preprocessrownum","",5), 
                                                    helpText("percent of all genes in the dataset"))                                   
                  ),
                  
                  conditionalPanel(condition="input.MainMenu=='Ordering'",
                                   wellPanel(
                                         checkboxInput("Orderinguploadordering","Upload your own cell ordering",value=F),
                                         conditionalPanel(condition="input.Orderinguploadordering=='1'",
                                                          wellPanel(
                                                                h5("Input Dataset"),
                                                                fileInput('OrderingFile', 'Choose File'),
                                                                p(actionButton("Orderingreadin","Read in")),
                                                                checkboxInput('Orderingheader', 'Header', TRUE),
                                                                radioButtons('Orderingsep', 'Separator',
                                                                             c('Tab'='\t',
                                                                               'Space'=' ',
                                                                               'Comma(csv)'=',',
                                                                               'Semicolon'=';'
                                                                             ),
                                                                             '\t'),
                                                                radioButtons('Orderingquote', 'Quote',
                                                                             c('None'='',
                                                                               'Double Quote'='"',
                                                                               'Single Quote'="'"),
                                                                             '')
                                                          )               
                                         ),
                                         
                                         conditionalPanel(condition="input.Orderinguploadordering=='0'",                                                      
                                                          radioButtons("Orderingchoosestep","",list("Step 1: Dimension reduction"="reduction","Step 2: Pseudo time reconstruction"="ptime","Save results (optional)"="save")),
                                                          conditionalPanel(condition="input.Orderingchoosestep=='reduction'",
                                                                           wellPanel(
                                                                                 radioButtons("Orderingdimredmet","Choose dimension reduction method",c("Principal Component Analysis (PCA)"="PCA","Independent Component Analysis (ICA)"="ICA"))
                                                                           ),
                                                                           helpText("Warning: ICA could be extremely slow for large datasets, use with care!"),
                                                                           sliderInput("Orderingdimredncomp","Choose number of components",min = 2,max = 20,step = 1,value = 2),
                                                                           conditionalPanel(condition="input.Orderingdimredmet=='PCA'",
                                                                                            p("Automatically select optimal dimension for PCA"),
                                                                                            p(actionButton("Orderingdimredoptbut","Select")),
                                                                                            checkboxInput("Orderingshowvarianceplottf","Show explained standard deviation plot for PCA",value=F)
                                                                           )
                                                          ),
                                                          conditionalPanel(condition="input.Orderingchoosestep=='ptime'",
                                                                           wellPanel(
                                                                                 radioButtons("Orderingptimechoosemethod","Choose reconstruction method",choices=list("TSCAN"="TSCAN","Monocle"="Monocle"))
                                                                           ),           
                                                                           uiOutput("Orderingptimeui"),
                                                                           checkboxInput("Orderingptimetrimtf","Trim branch/cell",value=F),
                                                                           uiOutput("Orderingptimetrimui"),
                                                                           checkboxInput("Orderingptimezoomintf","Zoom in plot",value=F),
                                                                           uiOutput("Orderingptimezoominui")
                                                                           #textInput("Orderingptimescale","Set maximum pseudo time",value=100)                                                                           
                                                          ),
                                                          conditionalPanel(condition="input.Orderingchoosestep=='start'&&input.Orderingptimechoosemethod=='TSCAN'",
                                                                           helpText("Use marker genesets to determine starting point. Average expression value is used for each geneset."),
                                                                           uiOutput("Orderingstartchoosemarkerui"),
                                                                           selectInput("Orderingstartchoosegenetrend","Choose geneset trend",choices = list("Monotone increasing"="increasing","Monotone decreasing"="decreasing","Not clear"="No")),
                                                                           p(actionButton("Orderingstartaddbutton","Add geneset")),
                                                                           uiOutput("Orderingstartincludegenesetui"),
                                                                           checkboxInput("Orderingstartscalegeneset","Scale gene expression levels",value=T)
                                                                           
                                                          ),
                                                          conditionalPanel(condition="input.Orderingchoosestep=='save'",
                                                                           p("Save pseudo time ordering list"),
                                                                           selectInput("Orderingsavepdatatype","Choose file type",choices = c("txt","csv")),
                                                                           p(downloadButton("Orderingsavepdata")),
                                                                           p("Save pseudo time ordering plot"),
                                                                           checkboxInput("Orderingsaveplotparatf","Change titles",value=F),
                                                                           sliderInput("Orderingsaveplotfontsize","Adjust font size",min = 1,max=50,step=1,value=12),
                                                                           uiOutput("Orderingsaveplotparaui"),
                                                                           selectInput("Orderingsaveplottype","Choose plot type",choices = c("pdf","ps")),
                                                                           textInput("Orderingsaveplotfilewidth","Enter plot width (inches)",12),
                                                                           textInput("Orderingsaveplotfileheight","Enter plot height (inches)",12),
                                                                           p(downloadButton("Orderingsaveplot"))
                                                          )
                                         )
                                   )
                                   
                  ),
                  
                  conditionalPanel(condition="input.MainMenu=='Difftest'",
                                   helpText("Likelihood ratio test of comparing GAM and constant fit models. P-values are adjusted for multiple testing using FDR."),
                                   helpText("Notice that the calculation may take a long time"),
                                   p(actionButton("Difftestbutton","Calculate adjusted p-value")),
                                   textInput("Difftestfdrval","Select FDR cutoff",value=0.05),
                                   radioButtons("Difftestshowresultopt","",choices=list("Show all results"="all","Show filtered results"="filtering")),
                                   wellPanel(
                                         helpText("Save pvalue table"),
                                         selectInput("Difftestsavepvaltabletype","Choose file type",choices = c("txt","csv")),
                                         p(downloadButton("Difftestsavepvaltable"))
                                   ),
                                   wellPanel(
                                         helpText("Save heatmap"),
                                         selectInput("Difftestplottype","Choose plot type",choices = c("pdf","ps")),
                                         textInput("Difftestfilewidth","Enter plot width (inches)",12),
                                         uiOutput("Difftestfileheightui"),                                                                
                                         p(downloadButton("Difftestsaveplot"))
                                   )
                  ),
                  
                  conditionalPanel(condition="input.MainMenu=='Visualization'",
                                   uiOutput("Visualizationgeneselectui"),
                                   uiOutput("Visualizationmethodui"),
                                   wellPanel(
                                         helpText("Save plots"),
                                         selectInput("Visualizationplottype","Choose plot type",choices = c("pdf","ps")),
                                         textInput("Visualizationfilewidth","Enter plot width (inches)",12),
                                         uiOutput("Visualizationfileheightui"),                                                                
                                         p(downloadButton("Visualizationsaveplot"))
                                   )
                  ),
                  
                  conditionalPanel(condition="input.MainMenu=='Miscellaneous'",
                                   h5("Tools for comparing different cell orderings"),
                                   helpText("This is an independent tool which does not directly depend on previous analysis"),
                                   wellPanel(
                                         radioButtons("Compareinputopt","",list("Step 1: Input cell sub-population information"="sub","Step 2: Input cell ordering information"="order")),
                                         conditionalPanel(condition="input.Compareinputopt=='sub'",
                                                          h5("Input Subpopulation Dataset"),
                                                          fileInput('ComparesubFile', 'Choose File'),
                                                          p(actionButton("Comparesubreadin","Read in")),
                                                          checkboxInput('Comparesubheader', 'Header', TRUE),
                                                          radioButtons('Comparesubsep', 'Separator',
                                                                       c('Tab'='\t',
                                                                         'Space'=' ',
                                                                         'Comma(csv)'=',',
                                                                         'Semicolon'=';'
                                                                       ),
                                                                       '\t'),
                                                          radioButtons('Comparesubquote', 'Quote',
                                                                       c('None'='',
                                                                         'Double Quote'='"',
                                                                         'Single Quote'="'"),
                                                                       '')            
                                         ),
                                         conditionalPanel(condition="input.Compareinputopt=='order'",
                                                          h5("Input Cell Ordering Dataset"),
                                                          uiOutput("compareordernameui"),
                                                          fileInput('CompareorderFile', 'Choose File'),
                                                          p(actionButton("Compareorderreadin","Read in"), actionButton("Compareorderadddata","Add Ordering Data")),
                                                          checkboxInput('Compareorderheader', 'Header', TRUE),
                                                          radioButtons('Compareordersep', 'Separator',
                                                                       c('Tab'='\t',
                                                                         'Space'=' ',
                                                                         'Comma(csv)'=',',
                                                                         'Semicolon'=';'
                                                                       ),
                                                                       '\t'),
                                                          radioButtons('Compareorderquote', 'Quote',
                                                                       c('None'='',
                                                                         'Double Quote'='"',
                                                                         'Single Quote'="'"),
                                                                       '')
                                         )
                                   )                                                                     
                  ) ,width=3),
            
            mainPanel(
                  
                  uiOutput("showbusybar"),
                  
                  conditionalPanel(condition="input.MainMenu=='Input'",
                                   checkboxInput("Inputshowinstructiontf","Show instructions",value=T),
                                   uiOutput("Inputshowinstructionui"),
                                   uiOutput("Inputshowsummaryui")
                  ),
                  
                  conditionalPanel(condition="input.MainMenu=='Preprocess'",
                                   #                                   uiOutput("Preprocessstatusui")
                                   h5("Clustering results:"),
                                   helpText("The averaged gene expressions within each cluster are used in constructing pseudo-time cell ordering."),
                                   tableOutput("preprocessshowdata")
                  ),
                  
                  conditionalPanel(condition="input.MainMenu=='Ordering'",
                                   conditionalPanel(condition="input.Orderinguploadordering=='1'",
                                                    checkboxInput("Orderinguploadshowinstructiontf","Show instructions",value=T),
                                                    uiOutput("Orderinguploadshowinstructionui"),
                                                    uiOutput("Orderinguploadshowpdataui")
                                   ),
                                   conditionalPanel(condition="input.Orderinguploadordering=='0'",
                                                    conditionalPanel(condition="input.Orderingchoosestep=='reduction'",                                                                     
                                                                     plotOutput("Orderingreductionshowplot",width = "800px",height = "800px"),
                                                                     plotOutput("Orderingreductionshowvariance",width = "800px",height = "800px")
                                                    ),
                                                    conditionalPanel(condition="input.Orderingchoosestep=='ptime'",
                                                                     tabsetPanel(
                                                                           tabPanel("Plot",
                                                                                    checkboxInput("OrderingshowMSTTF","Show MST Sketch"),
                                                                                    conditionalPanel(condition="input.OrderingshowMSTTF==1",h5("Note:"),p("The positions of clusters on the sketch and on the main plot are not the same."),plotOutput("OrderingshowMST",width = "400px",height = "400px")),
                                                                                    plotOutput("Orderingptimeshowplot",width = "800px",height = "800px"),plotOutput("Orderingptimeclustershowplot",width = "400px",height = "400px")),
                                                                           tabPanel("Pseudo time",dataTableOutput("Orderingptimeshowptime")),
                                                                           tabPanel("Trim expression",
                                                                                    h5("This tabset shows the details of trimming cells according to expression values"),
                                                                                    h5("List of criterion:"),
                                                                                    tableOutput("trimexprlistshowtable"),
                                                                                    h5("Trimmed cells:"),
                                                                                    textOutput("trimexprshowcelllist"),
                                                                                    h5("Gene expression heatmap:"),
                                                                                    plotOutput("trimexprshowheatmap")                                                                                    
                                                                           )
                                                                     )                                                    
                                                    ),
                                                    conditionalPanel(condition="input.Orderingchoosestep=='start'",                                                    
                                                                     uiOutput("Orderingstartmainui")                                         
                                                    ),
                                                    conditionalPanel(condition="input.Orderingchoosestep=='save'",
                                                                     tabsetPanel(
                                                                           tabPanel("Plot",plotOutput("Orderingsaveshowplot",width = "800px",height = "800px")),
                                                                           tabPanel("Pseudo time",dataTableOutput("Orderingsaveshowptime"))
                                                                     )                                                    
                                                    )
                                   )
                  ),
                  conditionalPanel(condition="input.MainMenu=='Difftest'",
                                   tabsetPanel(
                                         tabPanel("Gene list",textOutput("Difftestcalculatecomplete"),
                                                  uiOutput("Difftestsummaryui"),
                                                  dataTableOutput("Difftestshowresult")),
                                         tabPanel("Heatmap",uiOutput("Difftestheatmapui"))
                                   )
                                   
                  ),
                  conditionalPanel(condition="input.MainMenu=='Visualization'",
                                   uiOutput("Visualizationmainui")
                  ),
                  conditionalPanel(condition="input.MainMenu=='Miscellaneous'",
                                   uiOutput("Miscshowresultsui")
                  ),
                  conditionalPanel(condition="input.MainMenu=='About'",
                                   p('TSCAN: Tools for Single-Cell ANalysis'),
                                   p('Current Version: 1.0.0'),
                                   p('Release Date: 2014-10-16'),
                                   p('Author: Zhicheng Ji,Hongkai Ji'),
                                   p('Maintainer: Zhicheng Ji <zji4@jhu.edu>'),
                                   p(a("Visit my homepage",href="http://www.biostat.jhsph.edu/~zji4/",target="_blank")),
                                   p(a("Visit web page of our lab",href="http://www.biostat.jhsph.edu/~hji/",target="_blank"))                                   
                  )
                  
            )
            
      ))