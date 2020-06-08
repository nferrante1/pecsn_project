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
        string scenario = default("s1");
        string serviceTimeConfig = default("c1");
        int clients = default(3);
         @signal[responseTime](type="long");
    	@statistic[responseTimeStat](title="Response Time";source="responseTime"; record=stats,vector);
        
    submodules:
        client[clients]: Client {
            @display("p=29,80;i=device/pc");
        }
        server: Server {
            @display("p=152,80;is=vl;i=device/server2");
        }
        remote_server: Remote_server {
            @display("p=274,80;i=device/server");
        }
    connections:
        server.out++ --> {  delay = 80ms; } --> remote_server.in;
        server.in++ <-- {  delay = 80ms; } <-- remote_server.out;

        for i=0..clients-1 {
            client[i].out --> {  delay = 40ms; } --> server.in++;

            client[i].in <-- {  delay = 40ms; } <-- server.out++;
        }

}
