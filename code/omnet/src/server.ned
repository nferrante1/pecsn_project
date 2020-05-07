//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
// 

package pecsn_project;

module Server
{
    parameters:
        int clients = default(3);
        double p1 = default(0.33);
        double p2 = default(0.33);
    gates:
        input in[];
        output out[];
    submodules:
        disk: Disk {
            @display("p=104,56;i=device/disk");
        }
        processor: Processor {
            @display("p=104,121;i=device/cpu");
        }

    connections:
        //Connections from processor to disk
        processor.out++ --> {  delay = 1ms; } --> disk.in; //out[0] -> disk
        processor.in++ <-- {  delay = 1ms; } <-- disk.out; // in[0] proc <- disk

        //Connections from processor to remote_server
        processor.in++ <-- {  delay = 1ms; } <-- in++; //in[1] <- in[0] server (query)
        processor.out++ --> {  delay = 1ms; } --> out++; //out[1] -> out[0] server (query)

        //Connections from processor to client
        for i=0..clients-1 {
            processor.in++ <-- {  delay = 1ms; } <-- in++;    //in[2+] proc  <- in[0+] server
            processor.out++ --> {  delay = 1ms; } --> out++; //out[2+] proc -> out[0+] server
        }


}
