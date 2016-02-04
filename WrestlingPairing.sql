use udb_ctheis
go

with PlayerMatch as (
	select p1.ID as P1ID, p2.ID as P2ID,
		MatchScore		=	case when 	p1.ID = p2.ID then 9999999 else 0 end+	--Same Player
							abs((p1.Age+p1.Grade) - (p2.Age+p2.Grade))^4+		--Age Grade Score
							power((select max(v) from (values (p1.[weight]),(p2.[weight])) as value(v))/(select min(v) from (values (p1.weight),(p2.weight)) as value(v)),40)+ --Weight Score
							case when p1.ClubID = p2.ClubID then 50 else 0 end+ --Club Score
							case when p1.ExperienceID = p2.experienceID then 0 when abs(p1.ExperienceID - p2.ExperienceID) = 1 then 50 else 200 end --Experience Score
	from WrestlingTournamentParticipant	p1
	join WrestlingTournamentParticipant	p2
	on p1.ID	<>	p2.ID
	),
MatchRank as (
	select *, rn	=	ROW_NUMBER() over (partition by P1ID order by MatchScore)
	from PlayerMatch
	),
Match1 as (  --best matches
	select mr1.*
	from MatchRank	mr1
	join MatchRank	mr2	on	mr1.MatchScore	=	mr2.MatchScore
						and	mr1.P2ID		=	mr2.P1ID
						and mr2.P1ID		=	mr1.P2ID
	where mr1.rn	=	1
		and	mr2.rn	=	1
	)
select mr.*
from MatchRank		mr
left join Match1	m1	on	mr.P1ID	=	m1.P1ID
						and	mr.P2ID	=	m1.P2ID
where m1.MatchScore	is null
	and mr.rn = 1
order by mr.MatchScore desc