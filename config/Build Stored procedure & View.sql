USE [SDMCenter]
GO
/****** Object:  StoredProcedure [dbo].[sp_StuInfo]    Script Date: 2017/4/2 下午 03:47:15 ******/
DROP PROCEDURE [dbo].[sp_StuInfo]
GO
/****** Object:  StoredProcedure [dbo].[sp_ClassInfo]    Script Date: 2017/4/2 下午 03:47:15 ******/
DROP PROCEDURE [dbo].[sp_ClassInfo]
GO
/****** Object:  StoredProcedure [dbo].[sp_CadreInfo]    Script Date: 2017/4/2 下午 03:47:15 ******/
DROP PROCEDURE [dbo].[sp_CadreInfo]
GO
/****** Object:  View [dbo].[vw_StuLeave]    Script Date: 2017/4/2 下午 03:47:15 ******/
DROP VIEW [dbo].[vw_StuLeave]
GO
/****** Object:  View [dbo].[vw_StuClsRec]    Script Date: 2017/4/2 下午 03:47:15 ******/
DROP VIEW [dbo].[vw_StuClsRec]
GO
/****** Object:  View [dbo].[vw_StuClsRec]    Script Date: 2017/4/2 下午 03:47:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_StuClsRec]
AS
SELECT  dbo.Students.STU_ID AS 學員代號, dbo.Students.Name AS 學員姓名, dbo.ClsMembers.Status AS 學員狀態, dbo.ClsMembers.LeaveDate AS 離開日期, 
               dbo.Classes.CLS_ID AS 班級代號, dbo.Classes.Class AS 班級名稱, dbo.Classes.BeginDate AS 開班日期, dbo.Classes.Site AS 上課地點, 
               dbo.Classes.Period AS 上課時段, dbo.Classes.Remark AS 班級備註, dbo.Titles.Title AS 班級職稱, dbo.Students.IsCurrent AS 學員存否, 
               dbo.Classes.IsCurrent AS 班級存否, dbo.Classes.EndDate AS 封班日期, dbo.Students.JoinDate AS 加入日期
FROM     dbo.Students INNER JOIN
               dbo.ClsMembers ON dbo.Students.STU_ID = dbo.ClsMembers.STU_ID INNER JOIN
               dbo.Classes ON dbo.ClsMembers.CLS_ID = dbo.Classes.CLS_ID INNER JOIN
               dbo.Titles ON dbo.ClsMembers.TTL_ID = dbo.Titles.TTL_ID

GO
/****** Object:  View [dbo].[vw_StuLeave]    Script Date: 2017/4/2 下午 03:47:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_StuLeave]
AS
WITH StuLeave AS (SELECT  學員代號, 學員姓名, 班級代號, 班級名稱, 學員狀態, 加入日期, 離開日期
                               FROM      dbo.vw_StuClsRec AS SCR
                               WHERE   (班級存否 = 1) AND (學員狀態 = '離開') AND (班級職稱 = '班員'))
    SELECT  班級名稱, 離開日期, 學員代號, 學員姓名, 加入日期, 學員狀態
   FROM     StuLeave AS SL
   WHERE   (NOT EXISTS
                      (SELECT  班級代號
                      FROM     dbo.vw_StuClsRec AS SCR
                      WHERE   (班級存否 = 1) AND (學員狀態 = '參與') AND (班級職稱 = '班員') AND (SL.學員代號 = 學員代號)))

GO
/****** Object:  StoredProcedure [dbo].[sp_CadreInfo]    Script Date: 2017/4/2 下午 03:47:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[proc_CadreList]    Script Date: 2017/3/3 下午 05:33:42 ******/
CREATE PROCEDURE [dbo].[sp_CadreInfo] --Store Procedure的名稱，可自取
As 

--CTE:現有班級學員
with StuCurrent as(
	select *
	from  vw_StuClsRec SCR
	where SCR.班級存否 = 1
		  AND SCR.學員狀態 = '參與'
		  AND SCR.班級職稱 = '班員'
)

SELECT SCR.學員代號
	  ,SCR.學員姓名 幹部姓名
      ,SCR.班級名稱 護持班級
	  --,SCR.學員狀態 幹部狀態
      ,SCR.班級職稱
	  ,SCR.上課時段	護持時段
	  ,SC.班級名稱	母班
	  ,SC.上課地點	母班時段
FROM  vw_StuClsRec SCR
	  left join StuCurrent SC on SC.學員代號=SCR.學員代號
WHERE SCR.班級職稱 not in ('班員','暫停班員')
	  AND SCR.班級存否 = 1	--現任班級的班幹部
	  AND SCR.學員狀態 = '參與'--現任班級的班幹部

GO
/****** Object:  StoredProcedure [dbo].[sp_ClassInfo]    Script Date: 2017/4/2 下午 03:47:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[sp_ClassInfo]
As 

DECLARE @dateToDo datetime
SET @dateToDo = GETDATE();
--set @dateToDo=( DATEADD(day,-1,DATEADD(mm, DATEDIFF(m,0,getdate())+1,0)) )

--CTE:現有班級學員
with StuCurrent as(
	select *
	from  vw_StuClsRec SCR
	where SCR.班級存否 = 1
		  AND SCR.學員狀態 = '參與'
		  AND SCR.班級職稱 = '班員'
),

--CTE:現有班級的班長
Squad as(
	select SCR.班級代號
		  ,SCR.學員姓名
	from  vw_StuClsRec SCR
	where SCR.班級存否 = 1
		  AND SCR.學員狀態 = '參與'
		  AND SCR.班級職稱 = '班長'
)

--Main Query
select 班級
	  --,ISNULL(班長,'') 班長
	  ,年份
	  ,季別
      ,isnull(類型,'') 類型
	  ,isnull(
		   case when 地區 like '%台中%' then
				case when 班級	   like '%中科%' then '中科' 
					 when 班級	   like '%逢甲%' then '中科' 
					 when 班級	   like '%宗%'   then '宗行' 
					 when 班級	   like '%備%'   then '備覽' 
					 when 班級	   like '%善%'   then '善行' 
					 when 類型	   like '%企廣%' then '企廣'
					 when 類型	   like '%青廣%' then '青廣'
					 when 類型	   like '%長廣%' then '長廣'
					 when 類型	   like '%醫廣%' then '醫廣'
					 when 類型	   like '%CEO%'  then 'CEO'
					 when 上課時段 like '%一%'   then '週一'
					 when 上課時段 like '%二%'   then '週二'
					 when 上課時段 like '%三%'   then '週三'
					 when 上課時段 like '%四%'   then '週四'
					 when 上課時段 like '%五%'   then '週五'
					 end 
		   end
	   , '') 台中班群
	  ,系列,地區,上課地點,上課時段
      --,'' 開班人數
      ,現有人數
	  --,ISNULL(開班離開人數,0) 開班休學人數
	  --,ISNULL(年度離開人數,0) 年度休學人數
	  --,ISNULL(當月離開人數,0) 當月休學人數
	  --,isnull( cast(現有人數 as float)/cast(現有人數+開班離開人數 as float), 1) 開班保存率
	  --,isnull( cast(現有人數 as float)/cast(現有人數+年度離開人數 as float), 1) 年度保存率
	  --,isnull( cast(現有人數 as float)/cast(現有人數+當月離開人數 as float), 1) 當月保存率
	  
from (	
	select SC.班級名稱 班級
		  ,SC.班級代號 班級代號
		  ,S.學員姓名 班長 
		  ,'20' + SUBSTRING(SC.班級名稱,2,2) 年份
		  ,case when MONTH(開班日期) < 8 
			    then '春' else '秋' end 季別
		  ,case SUBSTRING(SC.班級名稱,4,1) 
				when '宗' then '宗行'
				when '備' then '備覽'
				when '善' then '善行'
				when '增' then '增上'
				when '春' then '一春'
				when '秋' then '一秋' end 系列
		  ,LEFT(SC.上課地點,2) 地區
		  ,SC.上課地點
		  ,SC.上課時段
		  ,COUNT(SC.班級名稱) 現有人數
		  ,case when SC.班級備註 like '%{%}%' 
				then substring(SC.班級備註, 
						charindex('{',SC.班級備註)+1, 
						charindex('}',SC.班級備註)-charindex('{',SC.班級備註)-1)
				end 類型
	from StuCurrent SC
		 left join Squad S on SC.班級代號 = S.班級代號
	group by SC.班級名稱,SC.開班日期,S.學員姓名,SC.上課地點
			,SC.上課時段,SC.班級備註,SC.班級代號
) QueryResult1

left join (	
	select SL.班級名稱 
		  ,COUNT(SL.班級名稱) 開班離開人數
	from vw_StuLeave SL
	where SL.離開日期 >= '1998/01/01' AND SL.離開日期 <= @dateToDo
	group by SL.班級名稱
) QueryResult2
on QueryResult1.班級 = QueryResult2.班級名稱

left join (	
	select SL.班級名稱 
		  ,COUNT(SL.班級名稱) 年度離開人數
	from vw_StuLeave SL
	where SL.離開日期 >= dateadd(yy, datediff(yy, 0, @dateToDo), 0) AND SL.離開日期 <= @dateToDo
	group by SL.班級名稱
) QueryResult3
on QueryResult1.班級 = QueryResult3.班級名稱

left join (	
	select SL.班級名稱 
		  ,COUNT(SL.班級名稱) 當月離開人數
	from vw_StuLeave SL
	where SL.離開日期 >= DATEADD(MONTH,-1,@dateToDo) AND SL.離開日期 <= @dateToDo
	group by SL.班級名稱
) QueryResult4
on QueryResult1.班級 = QueryResult4.班級名稱


GO
/****** Object:  StoredProcedure [dbo].[sp_StuInfo]    Script Date: 2017/4/2 下午 03:47:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[sp_member]    Script Date: 2017/3/7 下午 05:38:57 ******/
CREATE procedure [dbo].[sp_StuInfo]
AS 
   
SELECT SCR.學員代號
	  ,SCR.學員姓名
	  ,SCR.班級名稱 母班名稱
	  --,SCR.學員狀態 班級狀態
	  ,SCR.加入日期 開始學廣論的日期
	  ,SCR.離開日期
FROM  vw_StuClsRec SCR  
WHERE SCR.班級存否 = 1
	  AND SCR.學員狀態 = '參與'
	  AND SCR.班級職稱 = '班員'

Union

SELECT SL.學員代號
	  ,SL.學員姓名
	  ,'(中輟)' 母班名稱
	  --,SL.學員狀態 班級狀態
	  ,SL.加入日期 開始學廣論的日期
	  ,SL.離開日期
FROM vw_StuLeave SL
GO