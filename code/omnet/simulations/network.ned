package pecsn_project.simulations;

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

import pecsn_project.Client;
import pecsn_project.Remote_server;
import pecsn_project.Server;


network Network
{
    parameters: 
        int clients = default(3);
    submodules:
        client[clients]: Client {
            @display("p=29,80");
        }
        server: Server {
            @display("p=152,80;is=vl");
        }
        remote_server: Remote_server {
            @display("p=274,80");
        }
        connections:
        server.out++ --> {  delay = 40ms; } --> remote_server.in;
        server.in++ <-- {  delay = 40ms; } <-- remote_server.out;

        for i=0..clients-1 {
            client[i].out --> {  delay = 40ms; } --> server.in++;

            client[i].in <-- {  delay = 40ms; } <-- server.out++;
        }
            
}
