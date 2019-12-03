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

module Multiprog_server
{
    parameters:
        int m; //Multiprog grade;
        int n; //Numebr clients served
        @display("bgb=332,139");
    gates:

        inout clients[n];

    submodules:
        server_hw: Server_hw {
            @display("p=268,65");
        }
        server_sw: Server_sw {
            @display("p=131,65");
        }
    connections:

        server_hw.sw <--> server_sw.processor;
        for i=0..n {server_sw.io[i] <--> clients[i];}
}
