// Some doc string
package main

import (
	"fmt"
	"os"
	"bufio"
	"lgoTool/logentry"
	"lgoTool/extractors"
)


func main() {
	currentEntry := logentry.NewSimpleEntry()
	xyf := extractors.NewExtractor("xythos")
	inReader := bufio.NewReader(os.Stdin) 
	
	fmt.Println(currentEntry)
	fmt.Println(inReader.ReadString('\n'))
}
