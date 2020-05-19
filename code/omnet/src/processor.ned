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

simple Processor
{
    parameters:
        double serviceTimeMean = default(1.0);
        @signal[working](type="long");
    	@statistic[workingStat](title="Utilization";source="working"; record=stats,vector);
        @signal[complete](type="long");
    	@statistic[completedTransactions](title="Completed Transactions";source="complete"; record=stats,vector);
    	
    gates:
        input in[];
        output out[]; 
}
