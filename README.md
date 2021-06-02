
<br />
<p align="center">
  <h3 align="center">READ-ME MooveIT Challenge</h3>

  <p align="center">
    README for the MooveIT Ruby Challenge made by Mateo de Sierra
    <br />
  </p>
</p>



<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

This project was made by Mateo de Sierra, as part of the employee selection program for MooveIT. For this challenge a ruby implementation of Memcached was needed to be programmed. Memcached is an in-memory key-value store for small chunks of arbitrary data (strings, objects) from results of database calls, API calls, or page rendering.

### Built With

* [Ruby](https://www.ruby-lang.org/)
* [Rspec](https://rspec.info/)
* [VisualCode](https://code.visualstudio.com/)



<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple steps. (Guide made for Windows10)

### Ruby Instalation

1. Download the ruby installer for windows from this page:

   [Ruby](https://www.ruby-lang.org/)

2. Select the stable version (marked with an arrow on the versions page), and proceed with the instalation process

3. To check if ruby is correctly installed, go into a cmd and type "ruby -v", if ruby answers, it is correctly installed as seen next

   ![Ruby installed](https://i.imgur.com/sQmJasR.png)

### Server and Client Installation

1. Download the repo and unzip

   https://github.com/MateodeSierra/MooveITChallengeMateoDS)

2. Go into the repo folder, into the lib folder, and double click the "main.rb" file
3. If you reach this state the server is already running on the port displayed on screen

   ![Server running!](https://i.imgur.com/qSOW8B8.png)
4. To open a client, first you need to turn on telnet on your PC. To acomplish this, right click the Start button and select "Programs and Features", then click "Turn Windows features on or off" from the left hand menu.

5. The following window appears, scroll down and select Telnet Client, then press OK

   ![Telnet Selected](https://kencenerelli.files.wordpress.com/2017/07/telnet03_thumb.png?w=415&h=368)

6. Wait for the instalation to finish, after this, to test if telnet is correctly installed, go into cmd and type telnet. You can press help to see all available commands.

7. To open a client via Telnet, go into a new cmd and type "telnet localhost" followed by a space and the port number displayed on the server window.

8. If you reach this window, the client is running and you are connected to the server. You can start entering commands.

   ![Client connected!](https://i.imgur.com/QoZkzi6.png)

9. To close the client, just press the red cross on the top right corner.

### Test environment Installation

1. Download Visual Code or any other ruby capable source code editor  [VisualCode](https://code.visualstudio.com/)

2. Open Visual Code and install the Ruby extension

   ![Extension image](https://i.imgur.com/YQ70jGK.png)

3. Go into cmd and type "gem install rspec", this gem is used for testing the code

4. Once Rspec is intalled, go back into Visual Code and open your project folder, then right click the "memcached_spec.rb" file, and select "Open in Integrated Terminal".

   ![Open Terminal](https://i.imgur.com/52OM44p.png)

5. The opened terminal should look like this:

   ![Terminal](https://i.imgur.com/dE8AuTH.png)

6. To run the tests type "rspec ..\spec\memcached_spec.rb" into the terminal then press ENTER. If all tests run correctly all dots should be green and no error message should pop up. To check how tests work, double click the "memcached_spec.rb" file on your workspace folder.





<!-- USAGE EXAMPLES -->
## Usage

Memcached is a free & open-source, high-performance, distributed memory object caching system, generic in nature, but intended for use in speeding up dynamic web applications by alleviating database load.

This memcached implementation has the following working commands followed by the required arguments:

get:  (get (key))  **Multiple keys supported, enter them separated by a whitespace
* get retreives one or more keys from the server, returns the flag value, expiry time and value

gets: (gets (key))  **Multiple keys supported, enter them separated by a whitespace
* gets retreives one or more keys from the server, returns the flag value, expiry time, unique cas number and value

set: (set (key) (flag) (expire timy in seconds) (length of value in bytes)) Another line will appear, where the value needs to be entered. This value needs to be of the same length as the one entered by arguments.
* set stores data on the server

add: (add (key) (flag) (expire timy in seconds) (length of value in bytes)) Another line will appear, where the value needs to be entered. This value needs to be of the same length as the one entered by arguments.
* add stores data on the server, but only if the key isnt already stored.

replace: (replace (key) (flag) (expire timy in seconds) (length of value in bytes)) Another line will appear, where the value needs to be entered. This value needs to be of the same length as the one entered by arguments.
* replace stores data on the server, but only if the key already exists

append: (append (key) (flag) (expire timy in seconds) (length of value in bytes)) Another line will appear, where the value needs to be entered. This value needs to be of the same length as the one entered by arguments.
* append adds the entered value to the end of the existing value of the desired key

prepend: (prepend (key) (flag) (expire timy in seconds) (length of value in bytes)) Another line will appear, where the value needs to be entered. This value needs to be of the same length as the one entered by arguments.
* prepend adds the entered value before the existing value of the desired key

cas: (set (key) (flag) (expire timy in seconds) (length of value in bytes) (unique cas identifier)) Another line will appear, where the value needs to be entered. This value needs to be of the same length as the one entered by arguments.
* cas replaces the value of the desired key, but only if the unique cas identifier hasnt changed since the last time the client asked for it.



_For more examples, please refer to the [Documentation](https://github.com/memcached/memcached/blob/master/doc/protocol.txt)_




<!-- CONTACT -->
## Contact

Mateo de Sierra - themateods@gmail.com - [LinkedIN](https://www.linkedin.com/in/mateo-de-sierra-41a15b168/)

Project Link: [https://github.com/MateodeSierra/MooveITChallengeMateoDS](https://github.com/MateodeSierra/MooveITChallengeMateoDS)

