BEGIN {
	FS="\""
	# if we want to index this input for processing with other tools
	# do we need to keep an eye on the length of $0. We will use position as a counter
	position = 1 
	
	# Since we need to transform the date into a ISO8601 compliant format 
	# do we need to create a month transformation 
	monthNumber["Jan"]="01"
	monthNumber["Feb"]="02"
	monthNumber["Mar"]="03"
	monthNumber["Apr"]="04"
	monthNumber["May"]="05"
	monthNumber["Jun"]="06"
	monthNumber["Jul"]="07"
	monthNumber["Aug"]="08"
	monthNumber["Sep"]="09"
	monthNumber["Oct"]="10"
	monthNumber["Nov"]="11"
	monthNumber["Dec"]="12"
	
	# Extract the fields we want to output
	split(fields,fieldstoprint,",") 
	for (k in fieldstoprint) fieldstoprint[k]=toupper(fieldstoprint[k])	
	if (format=="") format="CSV"
	if (toupper(headers)=="YES" && toupper(format)=="CSV") {
		hdr = ""
		for (i = 1; i <= length(fieldstoprint); i++) hdr=sprintf("%s%s,",hdr,fieldstoprint[i])
		hdr = substr(hdr,1,length(hdr)-1) # Trim trailing comma
		printf "%s\n", hdr
	}
}

function safeString(inStr) {
	outStr = inStr
	if (format=="CSV") {
		if (match(inStr,",")>0) outStr=sprintf("\"%s\"",inStr)
	}
	return outStr
}

# Separator "
# $1 ip, -, id, date
# $2 = request
# $3 return code return size
# $4 user-agent
# $5 session id accesstime(ms) accesstime(s) size 
{
# $1 => POSITION, IP, USERID,DATE,TIME,TZ, DATETIME
	delete request
	request["POSITION"]=position
	split($1,x," ")
	unsetOffset = 0
	request["IP"]=x[1]
	request["USERID"]=x[3]
	if (x[3]=="{unset") {
		unsetOffset=1
		request["USERID"]=sprintf("%s %s",x[3],x[4])
	}  
	sub(/\[/,"",x[4+unsetOffset])
	sub(/\]/,"",x[5+unsetOffset])
	split(x[4+unsetOffset],dt,":")
	request["DATE"]=sprintf("%s",dt[1])
	request["TIME"]=sprintf("%s:%s:%s",dt[2],dt[3],dt[4])
	request["TZ"]=x[5+unsetOffset]
	# Also Create a proper ISO8601 date, called DATETIME
	split(dt[1],d,"/")
	request["DATETIME"]=sprintf("%s-%s-%sT%s:%s:%s%s",d[3],monthNumber[d[2]],d[1],dt[2],dt[3],dt[4],request["TZ"])
	delete d
	delete dt
	delete x

# We assume that we can print everything
fromIsOk=1
toIsOk=1	
# if from/to is specified, make sure that our DATETIME or TIME is in range
# TODO: if you do not specify TZ (+0100) in the datetime string will there be a seconds error in 'to' range
if (length(from)>0) {
  if (index(from,"T")>0) fromIsOk=(from<=request["DATETIME"])>0 
  	else fromIsOk=(from<=request["TIME"])>0 
}
if (length(to)>0) {
  if (index(to,"T")>0) toIsOk=(to>=request["DATETIME"])>0 
  	else toIsOk=(to>=request["TIME"])>0 
}


if (toIsOk>0 && fromIsOk>0) {	
# $2 => METHOD,FULLPATH,ROOTPATH,PARAMETERS,PROTOCOL
# Some of these will be enclosed in "" since they might cause problems for CSV output.
	split($2,x," ")
	request["METHOD"]=x[1]
	request["FULLPATH"]=x[2]
	request["PROTOCOL"]=x[3]
	delete x
	# Deal with query parameters. Can be queried with PARAM:value
	if (index(request["FULLPATH"],"?")>0) {
		split(request["FULLPATH"],x,"?")
		request["ROOTPATH"]=x[1]
		request["PARAMETERS"]=x[2]
		split(x[2],parameters,"&")
		for (pindex in parameters) {
			split(parameters[pindex],parameter,"=")
			pkey = sprintf("PARAM:%s",parameter[1])
			request[pkey]=parameter[2]
		}
		delete parameters	
	} 
	else {
	
		request["ROOTPATH"]=request["FULLPATH"]
		request["PARAMETERS"]="\"\""
	}

# $3 => STATUSCODE, SIZE
	split($3,x," ")
	request["STATUSCODE"]=x[1]
	request["SIZE"]=x[2]
	delete x

# $4 => USERAGENT 
# TODO: we might want to split this out in strings that can be queried, i.e. UAATTR:NSC etc etc
	request["USERAGENT"]=$4

# $5 => SESSIONID, REQTIME, REQTIMEMS
	split($5,x," ")
	request["SESSIONID"]=x[1]
	request["REQTIME"]=x[2]
	
	request["REQTIMEMS"]=x[3]

	if (format=="CSV") {
		outs = ""
		fCounter = 0
		for (i = 1; i <= length(fieldstoprint); i++) {
			if (match(fieldstoprint[i],/PARAM\:/)>0) { # Special handling to override casesenstivity
				paramprinted = 0
				for (field in request)  if (toupper(field)==fieldstoprint[i]) { 
					outs=sprintf ("%s%s,",outs,safeString(request[field]))
					paramprinted = 1
					fCounter += 1 
				}
			if (paramprinted==0) outs=sprintf("%s,",outs)
			}
 			else {
				outs=sprintf("%s%s,",outs,safeString(request[fieldstoprint[i]]))
				fCounter += 1
			}
		}
	}
	if (toupper(allfieldsreq)=="YES") { 
		if (fCounter==length(fieldstoprint)) print substr(outs,1,length(outs)-1) # Trim trailing comma
		} 
	else {
		print substr(outs,1,length(outs)-1) # Trim trailing comma
	}
}
	position += length($0)+1 # Add 1 to account for \n
}