course(complexity, time(monday,9, 11), lecturer(david,harel),      location(feinberg,a)).
course(phisics,    time(monday,9, 12), lecturer(david,harel),      location(feinberg,b)).
course(math,       time(monday,9, 11), lecturer(another,lecturer), location(feinberg,a)).
course(english,    time(monday,14,15), lecturer(maria,ivanovna),   location(feinberg,a)).
course(germany,    time(monday,14,15), lecturer(victor,petrovich), location(feinberg,a)).


%course(phisics, time(friday,10,12),lecturer(petr,harel),location(feinberg,b)).

%course(lp, time(monday, 2, 3), lecturer(shevchenko, igor, ivanovich), location(imcs, 332)).
%course(time_conflict, time(monday, 2, 4), lecturer(mister, x, y), location(imcs, 334)).
%course(lp, time(tuesday, 2, 3), lecturer(shevchenko, igor, ivanovich), location(imcs, 332)).
%course(place_conflict, time(tuesday, 2, 3), lecturer(mister, x, y), location(imcs, 332)).
%course(lecturer_conflict, time(tuesday, 2, 3), lecturer(shevchenko, igor, ivanovich), location(imcs, 334)).

%time(monday, 2, 3).
%time(monday, 3, 4).
%time(monday, 2, 4).
%time(friday, 2, 3).

course_name(Name, course(Name, _, _, _)).

day(Day, Course) :-
        course(Course, time(Day,_,_),_,_).

start_time(Start, Cource) :-
        course(Cource, time(_,Start,_),_,_).

finish_time(Finish, Course) :-
        course(Course, time(_,_,Finish), _, _).

building(Course, Building) :-
        course(Course,_,_,location(Building, _)).

room(Course, Room) :-
        course(Course,_,_,location(_, Room)).   

location(Course, Location) :-
        course(Course,_,_,Location).

lecturer(Lecturer, Course) :-
        course(Course, _, Lecturer, _).

duration(Course, Length) :-
        course(Course, time(_, Start, Finish), _, _),
        plus(Start, Length, Finish).

teaches(Lecturer, Day) :-
        course(_, time(Day, _, _), Lecturer, _).

occupied(Locatin, Day, Time) :-
        course(_, time(Day, Start, Finish), _, Locatin),
        Start =< Time, Time =< Finish.

occupied_2(Locatin, Day, Time, C) :-
        course(C, time(Day, Start, Finish), _, Locatin),
        Start =< Time, Time =< Finish.

between_time(time(GivenDay, GivenTime), time(Day, Start, Finish)) :-
        =(GivenDay, Day),
        between(GivenTime, Start, Finish).
       
crossed(pair(A, _), pair(C, D)) :- between(A, C, D).
crossed(pair(_, B), pair(C, D)) :- between(B, C, D).

crossed(A, _, C, D) :- between(A, C, D).
crossed(_, B, C, D) :- between(B, C, D).

crossed_time(time(Day1, Start1, Finish1), time(Day2, Start2, Finish2)) :-
        =(Day1, Day2),
        crossed(pair(Start1, Finish1), pair(Start2, Finish2)).

crossed_time(Day1, Start1, Finish1, Day2, Start2, Finish2) :-
        =(Day1, Day2),
        crossed(pair(Start1, Finish1), pair(Start2, Finish2)).

/*

schedule_conflict_crossed_time(GivenTime, _,
                               course(_, Time1, _, _),
                               course(_, Time2, _, _)) :-
        crossed_time(Time1, Time2),
        crossed_time(GivenTime, Time1),
        crossed_time(GivenTime, Time2).

*/
/*
  
schedule_conflict_time(GivenTime, 

                       course(_, Time1, _, _),
                       course(_, Time2, _, _)) :-
        between(GivenTime, Time1),
        between(GivenTime, Time2).

schedule_conflict_same_place(_, GivenPlace,
                             course(_, _, _, Location1),
                             course(_, _, _, Location2)) :-
        =(Location1, Location2),
        =(GivenPlace, Location1).

schedule_conflict_same_lecturer(_, _,
                                course(_, _, Lecturer1, _),
                                course(_, _, Lecturer2, _)) :-
        =(Lecturer1, Lecturer2).

schedule_conflict(GivenTime, GivenPlace, Course1, Course2) :-
        schedule_conflict_time(GivenTime, GivenPlace, Course1, Course2),
        schedule_conflict_same_place(GivenTime, GivenPlace, Course1, Course2),
        \=(Course1, Course2).

schedule_conflict(GivenTime, GivenPlace, Course1, Course2) :-
        schedule_conflict_time(GivenTime, GivenPlace, Course1, Course2),
        schedule_conflict_same_lecturer(GivenTime, GivenPlace, Course1, Course2),
        \=(Course1, Course2).
        
*/

  

%schedule_conflict(GivenTime, GivenPlace, Course1, Course2) :-
%        course(Cource1, time(Day1, Start1, Fin1), Lecturer1, Location1),
%        course(Cource2, time(Day2, Start2, Fin2), Lecturer2, Location2),
%        =(Day1, Day2).
% crossed_time()
        
%        \=(Course1, Course2).

=(A, B, C) :- =(A, B), =(B, C).

between(A, B, C) :- =<(B, A), =<(A, C).

time_inside_intervals(time(GivenDay, GivenTime),
                      time(Day1, Start1, Fin1),
                      time(Day2, Start2, Fin2)) :-
        =(Day1, Day2, GivenDay),
        between(GivenTime, Start1, Fin1),
        between(GivenTime, Start2, Fin2).

schedule_conflict(time(GivenDay, GivenTime), _, Course1, Course2) :-
        course(Course1, Time1, Lecturer1, _),
        course(Course2, Time2, Lecturer2, _),
        time_inside_intervals(time(GivenDay, GivenTime), Time1, Time2),
        =(Lecturer1, Lecturer2),
        \=(Course1, Course2).

schedule_conflict(time(GivenDay, GivenTime), GivenLocation, Course1, Course2) :-
        course(Course1, Time1, _, Location1),
        course(Course2, Time2, _, Location2),
        time_inside_intervals(time(GivenDay, GivenTime), Time1, Time2),
        =(Location1, Location2, GivenLocation),
        \=(Course1, Course2).
