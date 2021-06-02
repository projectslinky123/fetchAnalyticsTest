
declare @maxDate date = (select max(dateScanned) from receipt )
declare @startDate date = dateadd(day, 1-day(@maxDate),@maxDate)
declare @endDate date = dateadd(day, -1, dateadd(month, 1, @startDate))

select top 5 b.brandId, b.name, b.brandCode, numberOfReceipts = count(distinct r.receiptId)
from receipt r
	inner join receiptItem ri on ri.receiptId = r.receiptId
	inner join partnerItem p on ri.partnerItemid = p.partnerItemId
	inner join item i on i.itemid = p.itemId
	inner join brand b on b.brandid = i.brandid
where dateScanned between @startDate and @enddate
group by b.brandId, b.name, b.brandCode
order by 4 desc

/*** Assumed most recent month meant the current partial month and not the most recent full month.  ***/

/**** to ask the user who is goign to use the query that the receipts scanned is really what they want. 
	since a person can scan the receipt months(assuming) after purchase, which could scew the results based on what analysis they were doing  */ 

