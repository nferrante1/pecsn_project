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

package pecsn_project.simulations;

import pecsn_project.Client;
import pecsn_project.Multiprog_server;


network Net1
{
    parameters:
        int m; //Multiprogramming rate;
        int n; //Clients number
    submodules:
        client[n]: Client {
            @display("p=71,38");
        }
        multiprog_server: Multiprog_server {
            @display("p=186,84");
        }
	connections:
	    for i=0..n{client[i].server <--> multiprog_server.clients[i];}
}
