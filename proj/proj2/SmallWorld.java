/* Iteration 0, 2:31AM Sunday 3/24
 *
 * CS61C Spring 2013 Project 2: Small World
 *
 * Partner 1 Name: Michael Ball
 * Partner 1 Login: -mx
 *
 * Partner 2 Name: David Lau
 * Partner 2 Login: -hv
 *
 *
 * REMINDERS: 
 *
 * 1) YOU MUST COMPLETE THIS PROJECT WITH A PARTNER.
 * 
 * 2) DO NOT SHARE CODE WITH ANYONE EXCEPT YOUR PARTNER.
 * EVEN FOR DEBUGGING. THIS MEANS YOU.
 *
 */
import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.lang.Math;
import java.util.*;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.io.MapWritable;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
import org.apache.hadoop.mapreduce.lib.input.SequenceFileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat;
import org.apache.hadoop.mapreduce.lib.output.SequenceFileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;
import org.apache.hadoop.util.ReflectionUtils;

public class SmallWorld {
    // Maximum depth for any breadth-first search
    public static final int MAX_ITERATIONS = 20;

    /** Writeable node class */
    public static class Node implements Writable {
        public MapWritable children = new MapWritable();
        public MapWritable hotPaths = new MapWritable();
        public MapWritable coldPaths = new MapWritable();
        public static LongWritable trueWritable = new LongWritable(1);
        public static LongWritable nullWritable = new LongWritable(-1);
        public LongWritable isSelf = new LongWritable(1); //1 if self, 0 otherwise

        /** Empties hotPaths into coldPaths, destroying everything in hotPaths.
         *  @author Lau */
        public void cool() {
            Iterator<Writable> iterator = hotPaths.keySet().iterator();
            LongWritable key;
            LongWritable value;
            while (iterator.hasNext()) {
                key = (LongWritable) iterator.next();
                value = (LongWritable) hotPaths.get(key);
                value = new LongWritable(((LongWritable) value).get() + 1);
                if (!(coldPaths.keySet().contains(key))) {
                    coldPaths.put(key, value);
                }
            }
            hotPaths.clear();
        }
        public void write(DataOutput out) throws IOException {
            children.write(out);
            hotPaths.write(out);
            coldPaths.write(out);
            isSelf.write(out);
        }

        // Deserializes object - needed for Writable
        public void readFields(DataInput in) throws IOException {
            children.readFields(in);
            hotPaths.readFields(in);
            coldPaths.readFields(in);
            isSelf.readFields(in);
        }
        public String coldPaths() {
            String result = new String();
            result += "Cold Paths: ";
            for (Writable cold : coldPaths.keySet()) {
                result += cold + ":" + coldPaths.get(cold) + " ";
            }
            return result;
        }
        public String hotPaths() {
            String result = new String();
            result += "Hot Paths: ";
            for (Writable hot : hotPaths.keySet()) {
                result += hot + ":" + hotPaths.get(hot) + " ";
            }
            return result;
        }
        public String toString() {
            // We highly recommend implementing this for easy testing and
            // debugging. This version just returns an empty string.
            String result = new String();
            result += "Children: ";
            for (Writable child : children.keySet()) {
                result += child + " ";
            }
            return result;
        }
    }

    /** Deep copies a MapWritable.
     *  @author Lau */
    public static MapWritable copyWritable(MapWritable input) {
        MapWritable output = new MapWritable();
        for (Writable key : input.keySet()) {
            output.put(copyLong((LongWritable) key), copyLong((LongWritable) input.get(key)));
        }
        return output;
    }

    /** Deep copies a LongWritable.
     *  @author Lau */
    public static LongWritable copyLong(LongWritable input) {
        return new LongWritable(input.get());
    }

    /* The first mapper. Part of the graph loading process, currently just an 
     * identity function. Modify as you wish. */
    public static class LoaderMap extends Mapper<LongWritable, LongWritable, 
        LongWritable, LongWritable> {

        @Override
        /** Passes an A->B relation, and a B->null relation.
         *  @author Lau. */
        public void map(LongWritable key, LongWritable value, Context context)
                throws IOException, InterruptedException {

            context.write(key, value); //write source to destination
            context.write(value, new LongWritable(Long.MIN_VALUE)); //write destination to null
        }
    }

    /* The first reducer. This is also currently an identity function (although it
     * does break the input Iterable back into individual values). Modify it
     * as you wish. In this reducer, you'll also find an example of loading
     * and using the denom field.  
     */
    public static class LoaderReduce extends Reducer<LongWritable, LongWritable, 
        LongWritable, Node> {

        public long denom;

        /** Assigns all VALUES as children of the KEY. Randomly assigns the key to be a starting value.
         *  @author Lau */
        public void reduce(LongWritable key, Iterable<LongWritable> values, 
            Context context) throws IOException, InterruptedException {
            // We can grab the denom field from context: 
            denom = Long.parseLong(context.getConfiguration().get("denom"));
            Node node = new Node();
            node.isSelf = Node.trueWritable;
            for (LongWritable value: values) { //for every child of the node
                if (value.get() != Long.MIN_VALUE) { //if that child isn't null
                    node.children.put(new LongWritable(value.get()), Node.nullWritable); //put that child into the node's children
                }
            }

            Random dice = new Random();
            if (dice.nextInt((int) denom) == 0) {
                node.hotPaths.put(key, new LongWritable(0)); //Start a zero-length path at this node
            }
            context.write(key, node);
        }
    }

    // ------- Add your additional Mappers and Reducers Here ------- //

    /** @author Lau */
    public static class SearchMap extends Mapper<LongWritable, Node, LongWritable, Node> {
        public LongWritable child;

        @Override
            /** Creates a new node (for reference/value issues). We load a "false" copy with all
             *  the hot paths and send these out to all the children. We then turn hot paths
             *  into cold ones and pass a "true" copy to the node.
             *  @author Lau. */
        public void map(LongWritable key, Node value, Context context)
                throws IOException, InterruptedException {

            Node nodeCopy = new Node();
            nodeCopy.hotPaths = copyWritable(value.hotPaths);
            nodeCopy.isSelf = Node.nullWritable;
            
            for (Writable child: value.children.keySet()) { //for every child
                child = new LongWritable(((LongWritable) child).get());
                context.write((LongWritable) child, nodeCopy); //Send a copy of each hot path to each child
            }
            value.cool();
            context.write(key, value);
        }
    }

    /** @author Lau */
    public static class SearchReduce extends Reducer<LongWritable, Node, LongWritable, Node> {

        public long denom;
        public int iter;

        /** For a given node KEY, processes all VALUES. Values with the isSelf flagged as true
         *  will pass all its children and cold paths to the key node. The other value nodes
         *  will simply propagate their hot paths.
         *  @author Lau. */
        public void reduce(LongWritable key, Iterable<Node> values, 
            Context context) throws IOException, InterruptedException {
            Node output = new Node();
            output.isSelf = Node.trueWritable;
            output.coldPaths = new MapWritable();
            Long shortPath;
            iter = Integer.parseInt(context.getConfiguration().get("iter"));
            Iterator<Writable> iterator;
            for (Node node : values) { //for every node passed in
                if (node.isSelf.get() == 1) { //if it receives data from itself
                    output.children = copyWritable(node.children); //copy all children
                    for (Writable cold : node.coldPaths.keySet()) {
                        output.coldPaths.put((LongWritable) cold, node.coldPaths.get(cold)); //manually copy all the cold paths
                    }
                } else { //otherwise, someone is sending in at least one path
                    for (Writable index : node.hotPaths.keySet()) { //for every start node that's just gotten here
                        output.hotPaths.put(new LongWritable(((LongWritable) index).get()), new LongWritable(iter + 1)); //add it and increment the fresh count by 1
                        }
                }
            }
            context.write(key, output);
        }
    }

    public static class HistogramMap extends Mapper<LongWritable, Node, LongWritable, LongWritable> {

        @Override
        /** Read the goddamn inline comments. Seriously!
         *  @author Lau */
        public void map(LongWritable key, Node value, Context context)
                throws IOException, InterruptedException {

            LongWritable distance;
            value.cool(); //Some hot paths haven't been handled yet, we handle them here
            for (Writable start : value.coldPaths.keySet()) { //for every start
                distance = (LongWritable) value.coldPaths.get(start); //grab the distance it's traveled
                context.write(copyLong((LongWritable) distance), new LongWritable(1)); //write in that distance once
            }
        }
    }

    public static class HistogramReduce extends Reducer<LongWritable, LongWritable, 
        LongWritable, LongWritable> {

        /** Add up the number of times each KEY has come through.
         *  @author Lau */
        public void reduce(LongWritable key, Iterable<LongWritable> values, 
            Context context) throws IOException, InterruptedException {
            int total = 0;
            Iterator<LongWritable> iterator = values.iterator();
            while (iterator.hasNext()) {
                total += 1;
                iterator.next();
            }
            context.write(new LongWritable(key.get() - 1), new LongWritable(total)); //-1 for some arithmetic shenanigans
        }
    }

    public static void main(String[] rawArgs) throws Exception {
        GenericOptionsParser parser = new GenericOptionsParser(rawArgs);
        Configuration conf = parser.getConfiguration();
        String[] args = parser.getRemainingArgs();
        
        int reducerCount = 24;

        // Pass in denom command line arg:
        conf.set("denom", args[2]);

        // Sample of passing value from main into Mappers/Reducers using
        // conf. You might want to use something like this in the BFS phase:
        // See LoaderMap for an example of how to access this value
        conf.set("inputValue", (new Integer(5)).toString());

        // Setting up mapreduce job to load in graph
        Job job = new Job(conf, "load graph");

        //Lau code starts here
        job.setNumReduceTasks(reducerCount);
        //Lau code ends here

        job.setJarByClass(SmallWorld.class);

        job.setMapOutputKeyClass(LongWritable.class);
        job.setMapOutputValueClass(LongWritable.class);
        job.setOutputKeyClass(LongWritable.class);
        job.setOutputValueClass(Node.class);

        job.setMapperClass(LoaderMap.class);
        job.setReducerClass(LoaderReduce.class);

        job.setInputFormatClass(SequenceFileInputFormat.class);
        job.setOutputFormatClass(SequenceFileOutputFormat.class);

        // Input from command-line argument, output to predictable place
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path("bfs-0-out"));

        // Actually starts job, and waits for it to finish
        job.waitForCompletion(true);

        // Repeats your BFS mapreduce
        int i = 0;
        while (i < MAX_ITERATIONS) {
        conf.set("iter", (new Integer(i)).toString());
            job = new Job(conf, "bfs" + i);
            job.setNumReduceTasks(reducerCount);
            job.setJarByClass(SmallWorld.class);

            // Feel free to modify these four lines as necessary:
            job.setMapOutputKeyClass(LongWritable.class);
            job.setMapOutputValueClass(Node.class);
            job.setOutputKeyClass(LongWritable.class);
            job.setOutputValueClass(Node.class);

            // You'll want to modify the following based on what you call
            // your mapper and reducer classes for the BFS phase.
            job.setMapperClass(SearchMap.class); // currently the default Mapper
            job.setReducerClass(SearchReduce.class); // currently the default Reducer

            job.setInputFormatClass(SequenceFileInputFormat.class);
            job.setOutputFormatClass(SequenceFileOutputFormat.class);

            // Notice how each mapreduce job gets gets its own output dir
            FileInputFormat.addInputPath(job, new Path("bfs-" + i + "-out"));
            FileOutputFormat.setOutputPath(job, new Path("bfs-"+ (i+1) +"-out"));

            job.waitForCompletion(true);
            i++;
        }

        // Mapreduce config for histogram computation
        job = new Job(conf, "hist");
        job.setNumReduceTasks(1);
        job.setJarByClass(SmallWorld.class);

        // Feel free to modify these two lines as necessary:
        job.setMapOutputKeyClass(LongWritable.class);
        job.setMapOutputValueClass(LongWritable.class);

        // DO NOT MODIFY THE FOLLOWING TWO LINES OF CODE:
        job.setOutputKeyClass(LongWritable.class);
        job.setOutputValueClass(LongWritable.class);

        // You'll want to modify the following based on what you call your
        // mapper and reducer classes for the Histogram Phase
        job.setMapperClass(HistogramMap.class); // currently the default Mapper
        job.setReducerClass(HistogramReduce.class); // currently the default Reducer

        job.setInputFormatClass(SequenceFileInputFormat.class);
        job.setOutputFormatClass(TextOutputFormat.class);

        // By declaring i above outside of loop conditions, can use it
        // here to get last bfs output to be input to histogram
        FileInputFormat.addInputPath(job, new Path("bfs-"+ i +"-out"));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));

        job.waitForCompletion(true);
    }
}
