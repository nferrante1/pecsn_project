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

module Server_hw
{
    @display("bgb=319,207");
    gates:
        inout sw;
    submodules:
        disk: Disk {
            @display("p=78,147");
        }
        processor: Processor {
            @display("p=161,47");
        }
        remote_server_handler: Remote_server_handler {
            @display("p=227,147");
        }
    connections:

        processor.disk <--> disk.processor;
        processor.remote <--> remote_server_handler.processor;
        processor.sw <--> sw;
}
