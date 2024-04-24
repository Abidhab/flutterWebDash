const rootRoute = "/";

const overviewPageDisplayName = "Overview";
const overviewPageRoute = "/overview";


const createSurveyPageDisplayName = "Create survey";
const createSurveyPageRoute = "/create survey";

const surveyPageDisplayName = "Survey";
const surveyPageRoute = "/survey";

const clientsPageDisplayName = "Clients";
const clientsPageRoute = "/clients";

const authenticationPageDisplayName = "Log out";
const authenticationPageRoute = "/auth";

const mySurveyPageDisplayName = "MySurvey";
const mySurveyPageRoute = "/MySur" ;

class MenuItem {
  final String name;
  final String route;

  MenuItem(this.name, this.route);
}



List<MenuItem> sideMenuItemRoutes = [
 MenuItem(overviewPageDisplayName, overviewPageRoute),
 MenuItem(createSurveyPageDisplayName, createSurveyPageRoute),
  MenuItem(surveyPageDisplayName, surveyPageRoute),
 MenuItem(clientsPageDisplayName, clientsPageRoute),
 MenuItem(authenticationPageDisplayName, authenticationPageRoute),
];
