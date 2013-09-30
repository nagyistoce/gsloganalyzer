package xythos

import (
	"time"
	"io"
	"lgoTool/logentry"
)


func ExtractEntry(i io.Reader, e *logentry.Entry) (err error, state logentry.State) {

	return nil, logentry.Complete
}

func ExtractTimestamp(s string) time.Time {

	return time.Now()
}

func IsMultilineExtractor() bool {
	return true
}