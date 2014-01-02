
$(document).ready(function() {
  //RoboExperiment.runMalawiTest();
  RoboExperiment.runMultiYearTest(1995,2011);
});

var RoboExperiment = {
  requestsSent: 0,
  totalScores: {
    correct:0,  //# times a correct code from robo
    extra:0,    //# times an extra code from robo
    missed:0,   //# times a code was missed by robo
    numProjects:0, //# projects tested
    numProjectsMissed:0, //# of projects that robo missed at least one activity code
    numProjectsExtra:0,  //# of projects that robo had at least one extra activity code
    numPerfectCodings:0, //# of perfect codings by robo
    avgDescLength:0,
  },
  runMalawiTest: function(){
    console.log("Running Malawi Tests");
    var malawiParams = {
      src:'1,2,3,4,5,6,7,3249668',
      ro:110593668,
      y:'2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013',
      t:1,
      from:0,
      size:MAX_PAGE_SIZE,
      page:0,
      per_page:MAX_PAGE_SIZE
    };
    this.getProjects(malawiParams);
  },
  runMultiYearTest: function(startYear, endYear){
    console.log("Running MultiYear Test");
    var allParams = {
            src:'1,2,3,4,5,6,7,3249668',
            y:startYear,
            t:1,
            from:0,
            size:MAX_PAGE_SIZE,
            page:0,
            per_page:MAX_PAGE_SIZE
    };

    for(var year = startYear; year<= endYear; year++){
      allParams.y = year;
      this.getProjects(allParams);
    }
  },
  getProjects: function(params){
     $.ajax({
            type:  "GET",
            url: AIDDATA_API_URL + "aid/project",//http://api.aiddata.org/data/origin/providers]
            data: params
          })
          .done(function(projects) {
            for(var i=0;i<projects.items.length;i++){
              RoboExperiment.getProject(projects.items[i].project_id);
            }
           });
  },
  getProject: function (projectId){
    $.ajax({
            type:  "POST",
            url: AIDDATA_API_URL + "aid/project/"+projectId
          })
          .done(function(project) {
              if(project){
                var fullText = project.title +' '+ project.short_description + ' '+ project.long_description;
                var activityCodes = project.sector7;
                if(!activityCodes){
                  activityCodes=[];
                }

                if (fullText.length > MIN_DESCRIPTION_LENGTH){
                  RoboExperiment.getRoboCode(project.title, fullText, activityCodes);
                }
              }
           });
  },
  getRoboCode: function (title, projectDescription, activityCodes){
    this.requestsSent++;
    $.ajax({
      type:  "POST",
      url: ROBOCODER_API_URL + "static/classify.json",
      data: { description: projectDescription }
    })
    .done(function(roboResults){
        RoboExperiment.parseRoboResults(roboResults,title, projectDescription, activityCodes);
      });
  },
  parseRoboResults: function( roboResults,title, projectDescription, activityCodes) {
    var codes = this.compareRoboToArbi(roboResults,activityCodes);

    this.totalScores.numProjects++;
    this.totalScores.avgDescLength += projectDescription.length;
    this.totalScores.correct += codes.correct.length;
    this.totalScores.missed += codes.missed.length;
    this.totalScores.extra += codes.extra.length;

    if(codes.missed.length > 0 ){
      this.totalScores.numProjectsMissed++;
    }
    if(codes.extra.length > 0 ){
      this.totalScores.numProjectsExtra++;
    }
    if(codes.extra.length == 0 && codes.missed.length == 0){
      this.totalScores.numPerfectCodings++;
    }

    this.requestsSent--;
    if(this.requestsSent==0){
      this.totalScores.avgDescLength = this.totalScores.avgDescLength/this.totalScores.numProjects;
      console.log(this.totalScores);
    }

    if(SHOW_RANDOM_SAMPLES){
      this.printRandomSample(title, projectDescription, codes);
    }
  },
  compareRoboToArbi: function(roboActivityCodes, arbiActivityCodes){
    var codes = {
      correct:[], // robocodes that match arbitrated
      extra:[],   // robocodes that weren't in arbitrated
      missed:[]   // arbitrated codes that robo missed
    };

    for(var r =0; r<roboActivityCodes.length; r++){
      for(var a =0; a<arbiActivityCodes.length; a++){
        if(roboActivityCodes[r].formatted_number == arbiActivityCodes[a].code){
          codes.correct.push(roboActivityCodes.splice(r,1));
          arbiActivityCodes.splice(a,1);
          r--;
          a--;
          break;
        }
      }
    }

    codes.extra = roboActivityCodes;
    codes.missed = arbiActivityCodes;
    return codes;
  },
  printRandomSample: function(title, projectDescription, codes){
    if(this.requestsSent % 5 == 0){
      console.log("--");
      console.log(projectDescription.length + ' - ' + title );
      console.log(codes);
    }
  }
}
