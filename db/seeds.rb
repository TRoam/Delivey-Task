# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Teaminfo.create(team_name: 'RR1', description: "This is description for RR1" ,po:"Tom1" ,qm:"Yan1" ,scrum_master:"Sean1",sponsor_manager:"Long")
    Teaminfo.create(team_name: 'RR3', description: "This is description for RR3" ,po:"Tom2" ,qm:"Yan2" ,scrum_master:"Sean2",sponsor_manager:"Long")
    Teaminfo.create(team_name: 'RR2', description: "This is description for RR2" ,po:"Tom3" ,qm:"Yan3" ,scrum_master:"Sean3",sponsor_manager:"Long")

    Projectinfo.create(projectID: "Pro1", description: "Description for 1st project",jira:"FCC101")
    Projectinfo.create(projectID: "Pro2", description: "Description for 2st project",jira:"ICR100")
    Projectinfo.create(projectID: "Pro3", description: "Description for 3st project",jira:"PSCD2012")
    Projectinfo.create(projectID: "Pro4", description: "Description for 4st project",jira:"FINOPSS12PT")

    Criterion.create(teaminfo_id: 1 ,projectinfo_id:1 , status: "red")
    Criterion.create(teaminfo_id: 1 ,projectinfo_id:2 , status: "red")
    Criterion.create(teaminfo_id: 1 ,projectinfo_id:3 , status: "red")
    Criterion.create(teaminfo_id: 2 ,projectinfo_id:1 , status: "red")
    Criterion.create(teaminfo_id: 2 ,projectinfo_id:3 , status: "red")
    Criterion.create(teaminfo_id: 2 ,projectinfo_id:4 , status: "red")
    Criterion.create(teaminfo_id: 3 ,projectinfo_id:1 , status: "red")
    Criterion.create(teaminfo_id: 3 ,projectinfo_id:2 , status: "green")
    Criterion.create(teaminfo_id: 3 ,projectinfo_id:4 , status: "red")

    Taktinfo.create(criterion_id:1,taktID: 1,start_time:Date.new(2013,2,3),end_time:Date.new(2013,3,3),reporter:"Roam")
    Taktinfo.create(criterion_id:1,taktID: 2,start_time:Date.new(2013,3,3),end_time:Date.new(2013,4,3),reporter:"Roam")
    Taktinfo.create(criterion_id:1,taktID: 3,start_time:Date.new(2013,4,3),end_time:Date.new(2013,5,3),reporter:"Roam")
    Taktinfo.create(criterion_id:2,taktID: 1,start_time:Date.new(2013,2,3),end_time:Date.new(2013,3,3),reporter:"Roam")
    Taktinfo.create(criterion_id:2,taktID: 2,start_time:Date.new(2013,3,3),end_time:Date.new(2013,4,3),reporter:"Roam")
    Taktinfo.create(criterion_id:3,taktID: 1,start_time:Date.new(2013,2,3),end_time:Date.new(2013,3,3),reporter:"Roam")
    Taktinfo.create(criterion_id:4,taktID: 1,start_time:Date.new(2013,2,3),end_time:Date.new(2013,3,3),reporter:"Roam")
    Taktinfo.create(criterion_id:4,taktID: 2,start_time:Date.new(2013,2,3),end_time:Date.new(2013,3,3),reporter:"Roam")
    Taktinfo.create(criterion_id:4,taktID: 3,start_time:Date.new(2013,2,3),end_time:Date.new(2013,3,3),reporter:"Roam")
    Taktinfo.create(criterion_id:4,taktID: 4,start_time:Date.new(2013,2,3),end_time:Date.new(2013,3,3),reporter:"Roam")
    Taktinfo.create(criterion_id:4,taktID: 5,start_time:Date.new(2013,2,3),end_time:Date.new(2013,3,3),reporter:"Roam")
    Taktinfo.create(criterion_id:5,taktID: 1,start_time:Date.new(2013,2,3),end_time:Date.new(2013,3,3),reporter:"Roam")
    Taktinfo.create(criterion_id:5,taktID: 2,start_time:Date.new(2013,2,3),end_time:Date.new(2013,3,3),reporter:"Roam")
    Taktinfo.create(criterion_id:5,taktID: 3,start_time:Date.new(2013,2,3),end_time:Date.new(2013,3,3),reporter:"Roam")
    Taktinfo.create(criterion_id:6,taktID: 1,start_time:Date.new(2013,2,3),end_time:Date.new(2013,3,3),reporter:"Roam")
    Taktinfo.create(criterion_id:7,taktID: 1,start_time:Date.new(2013,2,3),end_time:Date.new(2013,3,3),reporter:"Roam")
    Taktinfo.create(criterion_id:8,taktID: 1,start_time:Date.new(2013,2,3),end_time:Date.new(2013,3,3),reporter:"Roam")
    Taktinfo.create(criterion_id:8,taktID: 2,start_time:Date.new(2013,2,3),end_time:Date.new(2013,3,3),reporter:"Roam")
    Taktinfo.create(criterion_id:9,taktID: 1,start_time:Date.new(2013,2,3),end_time:Date.new(2013,3,3),reporter:"Roam")

    Testplan.create(taktinfo_id:1,plan_name:"ECH_TAKT1_FIT_RR1_1",test_type:"FIT",format:1,coverage:"80%",ok_rate:"90%",status:"Green",open_message:0,comment:"blablas",reporter:"Jim",automated:false)    
    Testplan.create(taktinfo_id:1,plan_name:"ECH_TAKT1_FIT_RR1_2",test_type:"FIT",format:2,coverage:"40%",ok_rate:"80%",status:"Red",  open_message:3,comment:"blablas",reporter:"Gim",automated:true)    
    Testplan.create(taktinfo_id:1,plan_name:"ECH_TAKT1_FIT_RR1_3",test_type:"FIT",format:3,coverage:"60%",ok_rate:"90%",status:"Red",open_message:4,comment:"blablas",reporter:"Jfim",automated:false)    
    Testplan.create(taktinfo_id:1,plan_name:"ECH_TAKT1_FIT_RR1_1",test_type:"PIT",format:1,coverage:"60%",ok_rate:"90%",status:"Red",open_message:2,comment:"blablas",reporter:"JiDm",automated:false)
    Testplan.create(taktinfo_id:1,plan_name:"ECH_TAKT1_FIT_RR1_4",test_type:"FIT",format:1,coverage:"80%",ok_rate:"90%",status:"Green",open_message:0,comment:"blablas",reporter:"Jim",automated:false)    
    Testplan.create(taktinfo_id:1,plan_name:"ECH_TAKT1_FIT_RR1_6",test_type:"pIT",format:2,coverage:"40%",ok_rate:"80%",status:"Red",  open_message:3,comment:"blabdflas",reporter:"Gim",automated:true)    


    Testplan.create(taktinfo_id:2,plan_name:"ECH_TAKT1_FIT_RR1_1",test_type:"FIT",format:1,coverage:"80%",ok_rate:"90%",status:"Green",open_message:0,comment:"blablas",reporter:"Jim",automated:false)    
    Testplan.create(taktinfo_id:2,plan_name:"ECH_TAKT1_FIT_RR1_2",test_type:"FIT",format:2,coverage:"40%",ok_rate:"80%",status:"Red",  open_message:3,comment:"blablas",reporter:"Gim",automated:true)    
    Testplan.create(taktinfo_id:2,plan_name:"ECH_TAKT1_FIT_RR1_3",test_type:"FIT",format:3,coverage:"60%",ok_rate:"90%",status:"Red",open_message:4,comment:"blablas",reporter:"Jfim",automated:false)    
    Testplan.create(taktinfo_id:2,plan_name:"ECH_TAKT1_FIT_RR1_1",test_type:"PIT",format:1,coverage:"60%",ok_rate:"90%",status:"Red",open_message:2,comment:"blablas",reporter:"JiDm",automated:false)
    
    Testplan.create(taktinfo_id:3,plan_name:"ECH_TAKT1_FIT_RR1_1",test_type:"FIT",format:1,coverage:"80%",ok_rate:"90%",status:"Green",open_message:0,comment:"blablas",reporter:"Jim",automated:false)    
    Testplan.create(taktinfo_id:3,plan_name:"ECH_TAKT1_FIT_RR1_2",test_type:"FIT",format:2,coverage:"40%",ok_rate:"80%",status:"Red",  open_message:3,comment:"blablas",reporter:"Gim",automated:true)    
    Testplan.create(taktinfo_id:3,plan_name:"ECH_TAKT1_FIT_RR1_3",test_type:"FIT",format:3,coverage:"60%",ok_rate:"90%",status:"Red",open_message:4,comment:"blablas",reporter:"Jfim",automated:false)    
    Testplan.create(taktinfo_id:3,plan_name:"ECH_TAKT1_FIT_RR1_1",test_type:"PIT",format:1,coverage:"60%",ok_rate:"90%",status:"Red",open_message:2,comment:"blablas",reporter:"JiDm",automated:false)
    
    Testplan.create(taktinfo_id:4,plan_name:"ECH_TAKT1_FIT_RR1_1",test_type:"FIT",format:1,coverage:"80%",ok_rate:"90%",status:"Green",open_message:0,comment:"blablas",reporter:"Jim",automated:false)    
    Testplan.create(taktinfo_id:4,plan_name:"ECH_TAKT1_FIT_RR1_2",test_type:"FIT",format:2,coverage:"40%",ok_rate:"80%",status:"Red",  open_message:3,comment:"blablas",reporter:"Gim",automated:true)    
    Testplan.create(taktinfo_id:4,plan_name:"ECH_TAKT1_FIT_RR1_3",test_type:"FIT",format:3,coverage:"60%",ok_rate:"90%",status:"Red",open_message:4,comment:"blablas",reporter:"Jfim",automated:false)    
    Testplan.create(taktinfo_id:4,plan_name:"ECH_TAKT1_FIT_RR1_1",test_type:"PIT",format:1,coverage:"60%",ok_rate:"90%",status:"Red",open_message:2,comment:"blablas",reporter:"JiDm",automated:false)
    
    Testplan.create(taktinfo_id:5,plan_name:"ECH_TAKT1_FIT_RR1_1",test_type:"FIT",format:1,coverage:"80%",ok_rate:"90%",status:"Green",open_message:0,comment:"blablas",reporter:"Jim",automated:false)    
    Testplan.create(taktinfo_id:5,plan_name:"ECH_TAKT1_FIT_RR1_2",test_type:"FIT",format:2,coverage:"40%",ok_rate:"80%",status:"Red",  open_message:3,comment:"blablas",reporter:"Gim",automated:true)    
    Testplan.create(taktinfo_id:5,plan_name:"ECH_TAKT1_FIT_RR1_3",test_type:"FIT",format:3,coverage:"60%",ok_rate:"90%",status:"Red",open_message:4,comment:"blablas",reporter:"Jfim",automated:false)    
    Testplan.create(taktinfo_id:5,plan_name:"ECH_TAKT1_FIT_RR1_1",test_type:"PIT",format:1,coverage:"60%",ok_rate:"90%",status:"Red",open_message:2,comment:"blablas",reporter:"JiDm",automated:false)
    
    Testplan.create(taktinfo_id:6,plan_name:"ECH_TAKT1_FIT_RR1_1",test_type:"FIT",format:1,coverage:"80%",ok_rate:"90%",status:"Green",open_message:0,comment:"blablas",reporter:"Jim",automated:false)    
    Testplan.create(taktinfo_id:6,plan_name:"ECH_TAKT1_FIT_RR1_2",test_type:"FIT",format:2,coverage:"40%",ok_rate:"80%",status:"Red",  open_message:3,comment:"blablas",reporter:"Gim",automated:true)    
    Testplan.create(taktinfo_id:6,plan_name:"ECH_TAKT1_FIT_RR1_3",test_type:"FIT",format:3,coverage:"60%",ok_rate:"90%",status:"Red",open_message:4,comment:"blablas",reporter:"Jfim",automated:false)    
    Testplan.create(taktinfo_id:6,plan_name:"ECH_TAKT1_FIT_RR1_1",test_type:"PIT",format:1,coverage:"60%",ok_rate:"90%",status:"Red",open_message:2,comment:"blablas",reporter:"JiDm",automated:false)
    
