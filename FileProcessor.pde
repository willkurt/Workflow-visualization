import java.io.FileInputStream;

import java.io.FileNotFoundException;

import java.util.ArrayList;

import java.util.HashMap;

import java.util.Scanner;





public class FileProcessor {



  //we only want to worry about items that actually start and complete within the list

  ArrayList validTransactions;

  ArrayList validTokens = buildValidTokens();



  //this will be a hashmaps of hashmaps, we'll make these objects a the

  //last second

  HashMap taskConnectMap; 





  public FileProcessor (String fileName)

  {

    validTransactions = parseForValidLines(fileName);

    taskConnectMap = new HashMap();

  }

  public HashMap getTaskConnectMap()
  {
    fillTaskConnectMap();
    return this.taskConnectMap;
  }


  public void fillTaskConnectMap()

  {

    //okay so iterate through the list of valid transaction,
    //create a connection for what ever is nex
    //minus 1 because we know that that last one has no next on ;)

    for(int i = 0; i<validTransactions.size()-1;i++)

    {

      //if you're not already in the taskMap, you need to be added
      if(!taskConnectMap.containsKey(validTransactions.get(i)))

      {

        //we all need add the item hashmap (so that you know the count for each tsk)
        HashMap child = new HashMap();

        for(int j = 0; j<validTokens.size();j++)

        {

          child.put((String)validTokens.get(j), new Integer(0));

        }

        taskConnectMap.put(validTransactions.get(i),child);

      }
      if(!isEndToken((String)validTransactions.get(i)))//terminating transactions do not connect to others
      {
        HashMap itemMap = (HashMap)taskConnectMap.get((String)validTransactions.get(i));

        //we're going to increment what comes next in our count
        Integer value = (Integer)itemMap.get(validTransactions.get(i+1));

        value = new Integer(value.intValue()+1);

        itemMap.put((String)validTransactions.get(i+1),value);
        taskConnectMap.put((String)validTransactions.get(i),itemMap);
      }
    }


    HashMap child = new HashMap();

    for(int j = 0; j<validTokens.size();j++)

    {

      child.put((String)validTokens.get(j), new Integer(0));

    }

    taskConnectMap.put((String)validTokens.get(validTokens.size()-1), child);
  }





  public HashMap buildTaskConnectMap()

  {

    HashMap rmap = new HashMap();



    for(int i = 0; i<validTokens.size();i++)

    {

      HashMap child = new HashMap();

      for(int j = 0; j<validTokens.size();j++)

      {

        child.put((String)validTokens.get(j), new Integer(0));

      }

      rmap.put((String)validTokens.get(i),child);

    }



    return rmap;

  }



  public ArrayList parseForValidLines(String fileName)

  {

    ArrayList rlist = new ArrayList();

    FileInputStream fs = null;

    try {

      fs = new FileInputStream(fileName);

    } 
    catch (FileNotFoundException e) {

      // TODO Auto-generated catch block

      e.printStackTrace();

    }





    boolean eating = false;

    Scanner scanner = new Scanner(fs);

    ArrayList buffer = new ArrayList();

    String nextLine;

    while(scanner.hasNextLine())

    {

      nextLine = scanner.nextLine();

      String nextToken = getToken(nextLine);

      if(isStartToken(nextLine))

      {

        //theoretically this should not happen unless a request starts and never finishes

        //I'll dump these since I only want to see what happens during the full life-cycle of a request

        if(eating)

        {

          //dump the old buffer

          buffer.clear();

          //add this new start

          buffer.add(nextToken);

        }

        else

        {

          //start scanning

          eating = true;

          buffer.add(nextToken);

        }



      }

      else if(isEndToken(nextLine))

      {

        //this means we successfully finished a set of transcations

        if(eating)

        {

          buffer.add(nextToken);

          for(int i = 0;i<buffer.size();i++)

          {

            rlist.add(buffer.get(i));

          }

          //finally clear the buffer

          buffer.clear();

          //and stop scanning

          eating = false;

        }

        else

        {

          //don't do anything since we can ignore this.

        }

      }

      else

      {

        if(eating)

        {

          buffer.add(nextToken);



        }

        else

        {



          //again if not eating don't do anything

        }

      }



    }



    return rlist;

  }



  public boolean isStartToken(String l)

  {

    ArrayList startTokens = new ArrayList();

    startTokens.add("Submitted by Customer");

    startTokens.add("Submitted via Lending Web");

    for(int i = 0;i<startTokens.size();i++)

    {

      if(l.contains((String)startTokens.get(i)))

      {

        return true;

      }

    }

    return false;

  }



  public boolean isEndToken(String l)

  {

    ArrayList endTokens = new ArrayList();

    endTokens.add("Cancelled by Customer");

    endTokens.add("Cancelled by ILL Staff");

    endTokens.add("Cancelled via Lending Web");

    endTokens.add("Request Finished");



    for(int i = 0;i<endTokens.size();i++)

    {

      if(l.contains((String)endTokens.get(i)))

      {

        return true;

      }

    }

    return false;

  }







  public ArrayList buildValidTokens()

  {

    ArrayList validTokens = new ArrayList();

    FileInputStream fs = null;

    try {

      fs = new FileInputStream("/Users/will/Documents/Processing/workFlows/data/tokens.txt");

    } 
    catch (FileNotFoundException e) {

      // TODO Auto-generated catch block

      e.printStackTrace();

    }



    Scanner scanner = new Scanner(fs);

    while(scanner.hasNextLine())

    {

      validTokens.add(scanner.nextLine());

    }

    return validTokens;

  }



  public String getToken(String l)

  {



    for(int i = 0;i<validTokens.size();i++)

    {

      if(l.contains((String)validTokens.get(i)))

      {

        return (String)validTokens.get(i);

      }

    }



    //if we don't find it we'll return null

    return null;





  }





}




