package logentry

import (
	"time"
)

// TODO: Add stuff like:
//  preprocessing filters to remove/transform stuff from the instream
//  postprocessing filters to work on the Fields map
 
var Extractors map[string]ExtractorFunc

// State reflects where in the particular log entry processing the process is. 
type State int

const (
	Initialized State = 1 + iota
	Partial
	PartialWithError
	Complete
	CompleteWithError
)

// Entry simply defines a log entry 
type Entry struct {
	Timestamp time.Time
	Position  int
	State     State
	Fields    map[string]interface{}
}

func NewSimpleEntry() *Entry {
	
// Modelling after http.ServeHTTP etc
type ExtractorFunc func(io.Reader, *Entry) (error,State)

func RegisterExtractorFunc(typeId string, e ExtractorFunc) {
	Extractors[typeId] = e
}
