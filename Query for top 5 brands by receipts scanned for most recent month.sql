

select top 5 r.dateScanned, numberOfReceipts = count(distinct r.receiptId)
from receipt r
	inner join receiptItem ri on ri.receiptId = r.receiptId
	inner join partnerItem p on ri.partnerItemid = p.partnerItemId
	inner join item i on i.itemid = p.itemId
group by r.dateScanned
order by r.dateScanned

/**** to ask the user who is goign to use the query that the receipts scanned is really what they want. 
	since a person can scan the receipt months(assuming) after purchase, which could scew the results based on what analysis they were doing  */ 

